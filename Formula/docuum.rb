class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://github.com/stepchowfun/docuum/archive/v0.21.1.tar.gz"
  sha256 "6327d5e587460fb6cb10bfc10a7430b77a61926b49c919b2026e46592df2e0ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "621cd7b8f28627bce234a6895402f152bd81a81f97d91d34ef780226a5b81b28"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cceb92da75b1c92689b0ae2fa771c8b1e25e9662fa900be5b7a2cb568bef584c"
    sha256 cellar: :any_skip_relocation, monterey:       "e0109727463946234cd667db2eab532fd44094101d9be557fd7558747ec63cd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac7b4c69296ed79b6b78194bfbfbd2190e6c4be40b53c42f53b885636cc9d5d7"
    sha256 cellar: :any_skip_relocation, catalina:       "1124f7c27e284d40d95f0c7873b8e09d98e7af336771de826cd79d1a9405b766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc714a83fd2e0453d48f949236df6aebd7f4382bd5d6319d85321b2e0e292bf4"
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
