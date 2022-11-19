class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://github.com/stepchowfun/docuum/archive/v0.21.1.tar.gz"
  sha256 "6327d5e587460fb6cb10bfc10a7430b77a61926b49c919b2026e46592df2e0ac"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfc8e89ee290a93ceb44807aff1ccaa40770aa2f8095b2a723af5265150f220c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab2c74a8e347a168c2ab256fb9a1ab4550ec154512dd97eee0692f073539f48a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a582881590f643d644ff1e68c4ccc2fa8eb4b430ddb1a09d10ed21b03daddf56"
    sha256 cellar: :any_skip_relocation, monterey:       "89deb0bfd52a63954a6793693226ca5e03a66d93e2e4a5c257313288939ae7dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d4de732d806069a55a3e18e1adf2bbf5bb7ea0902f55edf28c9d11ade41586a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3209f1b1d5763c42b610fe2fe07f265341d1440e4718db2d053f109e407a6c49"
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
