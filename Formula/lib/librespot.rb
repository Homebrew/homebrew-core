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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "abd9e87ba45e5ae2e4a3798ca2042d068c2c6bc880d450e3f6e36259342061e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "da5d471665712fb34f147bd605b4f8f960c0e0fc8d9a5e47ca7b70ca0e9132f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a71699856a1c4ad908b3a1e5c9304a455d9cde1003a912da2d1298b0f9df73e0"
    sha256 cellar: :any,                 arm64_linux:       "b46f177d84157d8790d26bdb5ac8326e29e8e7586aaf9b156e3709e91a45e71d"
    sha256 cellar: :any,                 x86_64_linux:      "b026c712356b9cc4c6ae01b3a9f8e190b1fd3f31bd45ebc87caf279fd75d6e00"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@3" # https://github.com/librespot-org/librespot/pull/1707
  end

  def install
    if OS.mac?
      ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path.to_s
      args = %w[--no-default-features]
      # We use `with-dns-sd` on macOS since system Bonjour can be used.
      # Linux requires Avahi which isn't well maintained so better to use libmdns.
      features = %w[native-tls rodio-backend with-dns-sd]
    end

    system "cargo", "install", *args, *std_cargo_args(features:)
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
