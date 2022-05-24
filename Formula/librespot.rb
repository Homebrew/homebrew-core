class Librespot < Formula
  desc "Open Source Spotify client library"
  homepage "https://github.com/librespot-org/librespot"
  url "https://github.com/librespot-org/librespot/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "ae3ce1f3bd0031cac687eb60e08abb2d327ba51623c583765eda70376d69a71f"
  license "MIT"
  head "https://github.com/librespot-org/librespot.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1aea917c417867850ab16db7f7675fbf50a940dbe8453960cbc8136f36fa29ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bca119a263b2707c4f32cb7668df0e012cb2c7fec3c87dc5fbc1477057f02404"
    sha256 cellar: :any_skip_relocation, monterey:       "fa4f1a01eaec9a1e2607dc247f815dfed25297b0c805c88560abc4d56794b706"
    sha256 cellar: :any_skip_relocation, big_sur:        "4515f7262b393274dc4c7705e237ee31e3987100ab524724e559176f8a2222a6"
    sha256 cellar: :any_skip_relocation, catalina:       "11fbd6651d565f89bacc828813189ba18a74903be4e20b52841cc4614957c4be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d23317fd582b31581629249b51bdf66d285e9754ce8f263419f733fb6ac4247c"
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
