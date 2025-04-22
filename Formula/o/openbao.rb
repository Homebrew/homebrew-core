class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.2.0",
      revision: "a2bf51c891680240888f7363322ac5b2d080bb23"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c4289dcaa366e22dab85a9fcde2a740796f660e26f96cb97c6b13f33278c4c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0fde25b19955ce60558ef478a739a37c4358342ba031a451aeac10ab8cb4a7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7398c8b531df151df936e781d31d41e8861586bf662ed0462a7d66d5ebc9514f"
    sha256 cellar: :any_skip_relocation, sonoma:        "437d9bf8ebf4246f497ef3520828fb9ea07af33d09a2c03c5badce3a687f7f21"
    sha256 cellar: :any_skip_relocation, ventura:       "5a785bb4f0d235af8d59b29a4a8204de777a99872ab85309943700834e83416d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e17cb91593cca492f442eab303f00fcce13ec48755d558d2497d47480edf82a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "527df7748c0f9373dcc287a2437852d267d72b0e8d2d10e491ef92a10404a996"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build # failed to build with node 23, https://github.com/openbao/openbao/issues/731
  depends_on "yarn" => :build

  conflicts_with "bao", because: "both install `bao` binaries"

  def install
    ENV.prepend_path "PATH", Formula["node@22"].opt_libexec/"bin" # for npm
    system "make", "bootstrap", "static-dist", "dev-ui"
    bin.install "bin/bao"
  end

  service do
    run [opt_bin/"bao", "server", "-dev"]
    keep_alive true
    working_dir var
    log_path var/"log/openbao.log"
    error_log_path var/"log/openbao.log"
  end

  test do
    addr = "127.0.0.1:#{free_port}"
    ENV["VAULT_DEV_LISTEN_ADDRESS"] = addr
    ENV["VAULT_ADDR"] = "http://#{addr}"

    pid = spawn bin/"bao", "server", "-dev"
    sleep 5
    system bin/"bao", "status"
    # Check the ui was properly embedded
    assert_match "User-agent", shell_output("curl #{addr}/robots.txt")
  ensure
    Process.kill("TERM", pid)
  end
end
