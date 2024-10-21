class Librespot < Formula
  desc "Open Source Spotify client library"
  homepage "https://github.com/librespot-org/librespot"
  url "https://github.com/librespot-org/librespot/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "1af039ba08a2ad0d7b9758e8133229085845d1386018b90b455f011df27ee8df"
  license "MIT"
  head "https://github.com/librespot-org/librespot.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eda0f748e6fd8fa6bdc2d3d053a5f77b26fb82cdd7d5dcdf51015c8f30dfac37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83dc29f08d811c6a5f66e148728ae492a35c11943aac64ea154c36545461c5ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c5d16ee77dddba07e723c150bcc144a167cd983ba65409a350fff5a6dca6a23"
    sha256 cellar: :any_skip_relocation, sonoma:        "55cb2f725d55730f4b3dcef1e19fb5315d772cd48fdeb07e8e88b85008b7ef3f"
    sha256 cellar: :any_skip_relocation, ventura:       "da63fdd238553968dbaa0b1e68cabc8994e236d248014d256b066a2a1964399e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff80fbc9321c22cc8c06aa39e9c7fe58c6d7d6ce5eb71f671c949c9562392cd7"
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
