class Librespot < Formula
  desc "Open Source Spotify client library"
  homepage "https://github.com/librespot-org/librespot"
  url "https://github.com/librespot-org/librespot/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "cc8cb81bdbaa5abf366170dec5e6b8c0ecf570a7cb68f04483e9f7eed338ca61"
  license "MIT"
  head "https://github.com/librespot-org/librespot.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a15b917bd037910ec4eccef25e6687b51ce6e9bb7198610e65ebf95cf7941fe9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ccdf47ff268d6db2070778cfb1326d58decfffb3ea91d13e8660b769df36319"
    sha256 cellar: :any_skip_relocation, monterey:       "4bc0cf4306527bd9f1541e5ac45d0d42674c23aeb4d3bafc5a6d8c64bafa4166"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa7f4c33f5433245617a1da1a563af59eee77cd216a0bd5b3d70c13e7681cc27"
    sha256 cellar: :any_skip_relocation, catalina:       "64da966bdcbf551609849abd8adb39ef73a985e3a13ee3d025265cdf22c0d5e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f28855d8be40baa151ae9423557bc0e7ccb7d0617fa7ccb8c08049371695fb1"
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
