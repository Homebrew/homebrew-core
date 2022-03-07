class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://github.com/stepchowfun/docuum/archive/v0.20.5.tar.gz"
  sha256 "830aca5f43fb9cf1bef21657bd89ffe3bfa3829613f8b0a8e4f31b8c3058749d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "522dfc02c0e048df75890eb180260c029bbd2697b98b6e58f1a508000c5afd44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ba50a8305769c48caad3e9bbddaf5cbd158bb08ee0b1c0523a8d037e15bde6b"
    sha256 cellar: :any_skip_relocation, monterey:       "601f6974757e348ba9993f070bae3eca308f9d51462c72b80a866458bc78fabf"
    sha256 cellar: :any_skip_relocation, big_sur:        "31f94906755b535e2f7ced1370823ef9398a050bb6ad7b3b8c5eaa75f1ab4e86"
    sha256 cellar: :any_skip_relocation, catalina:       "4ac55b613e69442098752f2e8928397320842bb2541dab968a35a8ec39b4403e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4f68d38631516ce33424792b0cf638548df0d192534a508202b6ece3220728a"
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
