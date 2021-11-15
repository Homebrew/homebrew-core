class Librespot < Formula
  desc "Open Source Spotify client library"
  homepage "https://github.com/librespot-org/librespot"
  url "https://github.com/librespot-org/librespot/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "d360eaf61ad4216ee2c4a4d583d61c8ec7367b5efbe512011d049f73e4f24952"
  license "MIT"
  head "https://github.com/librespot-org/librespot.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "881400cd44d2aeb0af3e0fed1dcce1855bed0e60b60a78720c2b020fd8b073bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6127d387d29a582a1fbb6944c9b5fd18c4febbc483a3711e4248213fa4f01111"
    sha256 cellar: :any_skip_relocation, monterey:       "ac7a661b51abbc6324d597e35163862cc03b37583544152caaadc06a9cb69f4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8823b6d1718e2f8d6898c9306501a29ca36204159fd325725e02a187be77e325"
    sha256 cellar: :any_skip_relocation, catalina:       "bc83caa0485d4dd036f5bdc0643e9b10659799a3f0961442b2dcad349a9f3910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a65c6190910c07e93e5151813c1c868b7b7f9d97b0dcb582b9bda88226c87a7"
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
