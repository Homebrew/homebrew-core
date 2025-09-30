class Librespot < Formula
  desc "Open Source Spotify client library"
  homepage "https://github.com/librespot-org/librespot"
  url "https://github.com/librespot-org/librespot/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "1d09cf7a9b05663bc74806dc729dba818f2f1108728b60ccaac42bb54bf46864"
  license "MIT"
  head "https://github.com/librespot-org/librespot.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a5eff7a184388970a8d538f9018d9a2e2682b7d113f6886269bbc26c0b061c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95b5b73657b6c6319da0b199ae7e509e8fdd6835e41af52e06537635bb0bbf78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5283db5fd6dd968215ed62f6385c2301a310fab98c20891f90dec0b53c35dff3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af56224e37d14391051f7f5710e00c76170b099bb50f72a341f56415af650430"
    sha256 cellar: :any_skip_relocation, sonoma:        "b519d30ae4d8ce5efd85a20a0e2d9f427bc88c4e4d605e838d78b4c8a3f040b6"
    sha256 cellar: :any_skip_relocation, ventura:       "bae91410433aa1022a7ed80b577992376437255fe1878270f6d69121a9adf238"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "354c4b78c33bb7af9980db598767ce8ef340beeaca9d31a275bc948aacad7e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f33d462aade542a4e271125e9f4ec17f2137bcf303ab85acb90fdb8a9f205329"
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
