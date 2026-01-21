class Librespot < Formula
  desc "Open Source Spotify client library"
  homepage "https://github.com/librespot-org/librespot"
  url "https://github.com/librespot-org/librespot/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "0e4922997e1c67d27b3f50dcc388ecb8a3c08eba23b764879071f6e9e8c07ec7"
  license "MIT"
  head "https://github.com/librespot-org/librespot.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f29922e551c58ca9314a8866308fbc55681b5917d2ec6e9a329a9b7efe79647"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5c09746c4526ff5846d9a0560ee3cc1d021573937f34e898376b5d724cc6b55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c138bad37d6e3807668aad515b08b3f4cc45f2c7a720df700c80bd5599bbf38"
    sha256 cellar: :any_skip_relocation, sonoma:        "a837315473b98774a6a1411853646c5c819d836f21153cf4d5eabd327ab3f6c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3333c791b5881eced0fb758e2a8d4e861d55aaa7c9c91e09df0183bc7aa68737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fadc5ec56dc24bac05ceacc76486ab8326d4c3f6a5f4513a791bc80fa6bdbd0a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "avahi"
  end

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path.to_s if OS.mac?
    system "cargo", "install", "--no-default-features",
                               "--features", "rodio-backend,with-dns-sd,rustls-tls-native-roots",
                               *std_cargo_args
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
