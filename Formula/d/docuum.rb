class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://github.com/stepchowfun/docuum/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "26bf153c72185516db77ffabc00d75f0ae9d642792ccf204f843ceee94236756"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "adf63e1b78702983b47c7e4af2f12395b2d058983ebbaf22c2f508a90c375409"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "affa59dad018a494a5f1ebd4ae95e6923b5de38921385138f29874e8d3e52de9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c73857d61f8266046e879d12f4a527a8381c4e1320332cf9116ff25ba316820"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0cd97e7867b1fc163b34c9b74d34644c24899d3dfed2f330d09657359674ad3"
    sha256 cellar: :any_skip_relocation, sonoma:         "8774fc1059a912cc7f102617177f0c756b98b4e9f1d4781c630d8ce425b24042"
    sha256 cellar: :any_skip_relocation, ventura:        "18b42e43794e140650178212b3a20df43897e9766ee1b94f7faaa2ab6e4795f1"
    sha256 cellar: :any_skip_relocation, monterey:       "ec9aa82548bc0fee393165d179eb607f91e558d569bee74f1181b843c37d3f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bc6a5414cae362c54b12ee5cdff8212bce7f84a6f7bc670271796fb44d1a7ff"
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
