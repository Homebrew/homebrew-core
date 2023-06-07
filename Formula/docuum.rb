class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://github.com/stepchowfun/docuum/archive/v0.22.3.tar.gz"
  sha256 "9b42849a8e3fbb76c17f1b50ddf4d49899af82ed332682d8384979f3039735d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75260b40d0615bb45e1c64724034a897bbbdf51ca12aeb727591567f7e546e68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f866449c642e2e5d3382620e4efaf120e3c06a04d43ff4fc57e4fe6bb34ef16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cef52cda72f7a5f7c89d8a3186e722d97abb27eee77b13e1dc613508d93f0987"
    sha256 cellar: :any_skip_relocation, ventura:        "2ab2e823d7a04fe5e6783cb7ec2052947a07eec519737a929110866d8ec4ad40"
    sha256 cellar: :any_skip_relocation, monterey:       "3c5fd20e40e526ddd4c8633f4b137f5cf36cca9120a78f5c9e43531c90730fa5"
    sha256 cellar: :any_skip_relocation, big_sur:        "65e46f449fcbe46af192ff1929e8e2c66f4a0c717e48311b0c4aa3d24d2ac3fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9a89238020b92029798469a8469201543f6a80afedb037c315b9196ef57b4ff"
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
