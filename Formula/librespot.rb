class Librespot < Formula
  desc "Open Source Spotify client library"
  homepage "https://github.com/librespot-org/librespot"
  url "https://github.com/librespot-org/librespot/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "cd6e7ae63583584598dead53b5e8e4077ab37df6e3b59c2a7416459b9a649fc3"
  license "MIT"
  head "https://github.com/librespot-org/librespot.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "941078c067172d300d359f630613b529e3bfeda2c6ff2e3985a594e869178821"
    sha256 cellar: :any_skip_relocation, big_sur:       "1c8b87b2be64d5ef7821fdea43373b6fb36410cf6104bea177557671c3268eb7"
    sha256 cellar: :any_skip_relocation, catalina:      "229c58a8592a46fcb2c58648277cb704c959ce413132ead2ed299109c545d3aa"
    sha256 cellar: :any_skip_relocation, mojave:        "e94d0cb2f96785b6cca42615e650bd97d7ef9d9774eabf999f639af35f34cdc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd53933109cc9de3fa11f7413e07a40cca86d5a8bb0434fe359e7ea3731adbf4"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
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

    Open3.popen3({ "RUST_LOG" => "DEBUG" }, "#{bin}/librespot", "-v") do |_, _, stderr, wait_thr|
      Timeout.timeout(5) do
        stderr.each do |line|
          refute_match "ERROR", line
          break if line.include? "Zeroconf server listening"
        end
      end
    ensure
      Process.kill("INT", wait_thr.pid)
    end
  end
end
