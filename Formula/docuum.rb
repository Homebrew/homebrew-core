class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://github.com/stepchowfun/docuum/archive/v0.20.3.tar.gz"
  sha256 "a3a230ef718efb87eb5b42b0ffdaa87dd6df3ea64efe443e31c5fcf608a53580"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd0292dfe7161cd19af3258d502b34fe177db695e7d0db47432fa11ad73d2337"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd66c12ac9e8c81c8d4899b5882d05175cbb5a70bdd10cfbbd3a58a77247a35e"
    sha256 cellar: :any_skip_relocation, monterey:       "0a716d6bce640b9ccfe9ab7b9dd0151f57065fd3ccfa518fca48aeb8e9b5f929"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc871eccda08dd9bdd4cfb5bfc5665decd1881d63aa8aa7c30188ab4e7cc6658"
    sha256 cellar: :any_skip_relocation, catalina:       "4480c15b9438c3d94006156fd48d6bd3f563b906ab4c4da7081d62e131b79a48"
    sha256 cellar: :any_skip_relocation, mojave:         "d91f0318adf9203cb53e478089d657079b060f93d799948a46c73e72e2257805"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2e080677044824ea663785d3d19ef43ad48e30160b054f8a4cf053afc5dcd7b"
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
