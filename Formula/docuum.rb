class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://github.com/stepchowfun/docuum/archive/v0.20.5.tar.gz"
  sha256 "830aca5f43fb9cf1bef21657bd89ffe3bfa3829613f8b0a8e4f31b8c3058749d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3433c43d448845a7ded4102396bed5e0dc2600ac9cac53a950bf68e23292e1a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0e5a6a7aef178480c56ee865832a7766260972804fe45186c45ec171fcf9d72"
    sha256 cellar: :any_skip_relocation, monterey:       "e419b0e0e78110cd6e3a1fa7b61d6cd09c8d435e1c12e2de27c6b2d0baa6ebdb"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4eb0a5b9b334ee1a814b67c53483d0bec292c98851762d3733fe095219400a1"
    sha256 cellar: :any_skip_relocation, catalina:       "747bd07b374e67fe353b12a1cd90544d2d88def19826a08e9fcb91ce75ac27cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5332a07b4680ddddc6399a8c2d84e8093c00a0078ab279d3e288875408db0f27"
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
