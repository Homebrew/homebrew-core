class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://github.com/stepchowfun/docuum/archive/v0.21.0.tar.gz"
  sha256 "d23350f40a3a004120b7a8b96820bf4cc61147c8cc3424514cccbb95d2fc97ed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff164cce77b7b3e28551d9206dc52d91748ad53f169720232ae83957edee49f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fc4b1e4baad7e4cb583d5c85bbad65d61e7f4d6f437ce1b4e83a29652bd1c36"
    sha256 cellar: :any_skip_relocation, monterey:       "a87c1b976646cf155b6953787f3cc74f4643dd5d69648b065f7df9e69f825722"
    sha256 cellar: :any_skip_relocation, big_sur:        "995b7ea0e07deb7d6f4723b7515d3845c4e96fad2e3ad72fb73aad663add02dd"
    sha256 cellar: :any_skip_relocation, catalina:       "77b0a7af44208651f7bfcec8d8a171512c5994c65ed05c6463c851898072753e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7494bf54032c56cd8604f7af576b2976ac054f0b6e0e1b2b87dafe1497caef51"
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
    environment_variables PATH: std_service_path_env
  end

  test do
    started_successfully = false

    Open3.popen3({ "NO_COLOR" => "true" }, "#{bin}/docuum") do |_, _, stderr, wait_thread|
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
