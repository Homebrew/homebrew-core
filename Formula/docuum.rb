class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://github.com/stepchowfun/docuum/archive/v0.22.4.tar.gz"
  sha256 "d5653d1aaf5a0ea5d0122155cd482a57086e47b4c5fa4e4d6c8a774801765822"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1998523f2e7ee00a3893b04b907c47936a2f9673d128159ef8bdeb8ef4079ad2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91f26fc8c6e5bfe0f7a527e9d46cbb4e158cd08ee06b0b506134ceeddd8cdb37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "374dc2b41c9075bfb7a3eb8fdb9ceedaa9963397ad4dc48d8b173224c8fe1f78"
    sha256 cellar: :any_skip_relocation, ventura:        "c7d22bf0cced4b18c52b3bfbd15a80964135b76e888c004c0402f3a2eae939c0"
    sha256 cellar: :any_skip_relocation, monterey:       "0719108fcdb843450cd290a1a50fea33c0851e42d4ede180cd4e50ea5aab9b72"
    sha256 cellar: :any_skip_relocation, big_sur:        "f625120f9dd07688f19495e2c628887f2bf95d735875ed259215ba4b4695daa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78e83fbe523a9b5260362fd29a8671eaf0b44def71b745a5a9dc9683a4f25f0a"
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
