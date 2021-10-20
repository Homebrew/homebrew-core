class Librespot < Formula
  desc "Open Source Spotify client library"
  homepage "https://github.com/librespot-org/librespot"
  url "https://github.com/librespot-org/librespot/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "3ae67ac39606d049a26ee9e4b59f932222aac0098845ce3e1ef33c1b98080454"
  license "MIT"
  head "https://github.com/librespot-org/librespot.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7dde65331693b26799dc17b83b861a2a28e42fdef5c737ad859dc25d2b18db30"
    sha256 cellar: :any_skip_relocation, big_sur:       "1926141d397ff6dd7d6af509774e02e55654a40ccd5fed6710c25f808036390a"
    sha256 cellar: :any_skip_relocation, catalina:      "c1320dd2b002db2981de6fc6733d78826c2a4e8c4ed448761788224307c701c9"
    sha256 cellar: :any_skip_relocation, mojave:        "176c2bbb02d9550a528c582e84a19b79c1ab82fd5aa5041bf6c635969c592d17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f27d459c8b985861b710b302ac6c6dd65b86da16741b40e2b786ef989c289176"
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
