class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://github.com/stepchowfun/docuum/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "8e5f12bf28ae9eaada96c4087f298207dbc7c72e5daa94d6b39345dc9a4ec529"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "23846c400996f5f5a97b2347e9dc47cf8b0e879d0d67bc51836140240066086d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "03d5706517ef0f135fd58a278b264521fa6e4cc5c99cf266607828632ed7ac72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "71fbb71d9e44a179a51f4c6a5034be086cb782081bdff83f67e2725b211b6c9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "23f09dd2ffbd93f231becff8b392942f37508540b7a833048bdbfc79ecde3a24"
    sha256 cellar: :any,                 arm64_linux:       "028b2b0660a4ca07bd2fa244cfc474eeb2be1132ade1fdbd1f5d3fbb665ecdbb"
    sha256 cellar: :any,                 x86_64_linux:      "672d3f65b5ac4abdaa9c709459f4a877b3605cea3d322bfb79488ea98186532c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  # https://github.com/stepchowfun/docuum#configuring-your-operating-system-to-run-the-binary-as-a-daemon
  service do
    run opt_bin/"docuum"
    keep_alive true
    log_path var/"log/docuum.log"
    error_log_path var/"log/docuum.log"
    environment_variables PATH: "#{std_service_path_env}:/usr/local/bin"
  end

  test do
    started_successfully = false

    Open3.popen3({ "NO_COLOR" => "true" }, bin/"docuum") do |_, _, stderr, wait_thread|
      stderr.each_line do |line|
        if line.include?("Performing an initial vacuum on startup…")
          Process.kill("TERM", wait_thread.pid)
          started_successfully = true
        end
      end
    end

    assert(started_successfully, "Docuum did not start successfully.")
  end
end
