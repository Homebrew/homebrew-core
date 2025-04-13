class Librespot < Formula
  desc "Open Source Spotify client library"
  homepage "https://github.com/librespot-org/librespot"
  url "https://github.com/librespot-org/librespot/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "9ec881edb11e37d31a2b41dd30d56a3413445eedb720e1b0d278567dccfca8fc"
  license "MIT"
  head "https://github.com/librespot-org/librespot.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5a2cafcfec99611b21e631568c66d6f48fb44fe253082d3fe4243ffb5ff4735"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee2f9df22c5a0ea8db290f7bc39e14312023c478b740a1b78d6553dd195ad0be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e157e7a2cc3a41cb25808eacbc7baaa78af346439c3ed6b0f8b15863e275adec"
    sha256 cellar: :any_skip_relocation, sonoma:        "b377d7559eb6deab957dee9efbf6c8d0b855142619a798e1b2b0a9b61700db6e"
    sha256 cellar: :any_skip_relocation, ventura:       "451ba2f00bf2198de8ba55476b7bd6f63a59aabf6d1e344dcd8dea7caaf391c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "825316adc649d6ff25f4e650724a18b2ed780f0b5f9116baf0fb593444102c8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6561e113b24cb1d2d6e3a5850090e3bfa2a82950388c5fe7fb698dc3b6a333f2"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "alsa-lib"
    depends_on "avahi"
  end

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path.to_s if OS.mac?
    system "cargo", "install", "--no-default-features", "--features", "rodio-backend,with-dns-sd", *std_cargo_args
  end

  test do
    require "open3"
    require "timeout"

    Open3.popen3({ "RUST_LOG" => "DEBUG" }, bin/"librespot", "-v") do |_, _, stderr, wait_thr|
      Timeout.timeout(5) do
        stderr.each do |line|
          refute_match "ERROR", line
          break if line.include?("Zeroconf server listening")
        end
      end
    ensure
      Process.kill("INT", wait_thr.pid)
    end
  end
end
