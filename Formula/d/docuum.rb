class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://github.com/stepchowfun/docuum/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "3566064ff3bbb5f42a35fde10b7541def2a3cef4b12a7c6eecf2b84972c7459f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0305a71d7420d8ca112be910c40294febc7b70177cc48185519f0a09665df533"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82ce6edc531f9c8e706098c4a140fc46988ea0ed2be7e7e6a2ff3b3dc6f943d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89c40c16cdc37eedfe19a6ee535e2e3421ea2b9ec7f1da2c36d76da078f7e6a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0cdd27109e1fb24ec21a43d574ca9edf0b03d9fbe49ef88fe8c6301a2fb442e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4039f604d0693b9120873ca99445be60916d30ae37b81d29f84275d0ea019632"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "013ea6c9394f78b005b7773d5814902245c20aff030da5c9687a152a0fbd1f99"
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
