class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://github.com/stepchowfun/docuum/archive/v0.22.0.tar.gz"
  sha256 "dea91f697115ce15aeafaca3cf824ae2730947a8dae84b89815b1254c11ceff3"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71e6cb49a4074e577fb6e4e9d04c68ba76e3dd3355f369f6a73ae450b1b00d92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd78c93868f7328ad6dbfe2aeaba6b18b64e0c72a3b5eb140b8acd39f42bb415"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6e4b77f6386090d9662830ffa760e1ceb628cb1fbdcdf41b5cc2db757a71f97"
    sha256 cellar: :any_skip_relocation, ventura:        "0db3836b3063d8d028b27de730c2d41656f30781285a720c3694fbb535771263"
    sha256 cellar: :any_skip_relocation, monterey:       "e1b546c6b6b65d86ffbfefd87394b1de6888be914293a3e20a418c8a13699aa6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4ee4a38cea124be1aab6dab28bfa4dc449fc6e4225b7a25b24719e69eed2f93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1960ba1a0373201d1252e3b15aa86003c26d900969bebb12a6b8f505aea81ac7"
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
