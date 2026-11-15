class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://github.com/stepchowfun/docuum/archive/refs/tags/v0.27.3.tar.gz"
  sha256 "678b5f949e8b4b84d72fbc82a04c203d42ddf8ce10e8201131b8c2b964cb224e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5ea72985b2b2b2d6fd355a002b0d437893dc87fc7fa4990a87bcc2b8c003f21b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26599a4f791ac3ce4307629716cd3f997d0098d02b43358960c8f7c589d4b4a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eaf5a7981382fa0076c830a90d425f44e4df825ebad90c974385b675cbe66150"
    sha256 cellar: :any,                 arm64_linux:       "b0f442e3ee000009f3a5d942528890f54f6a1ae84ff3b5ee9a241278e732c55e"
    sha256 cellar: :any,                 x86_64_linux:      "c3727eaea41def05bf1171aace456996f07d8c0a77f25ef11dc36eaeabf47686"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
