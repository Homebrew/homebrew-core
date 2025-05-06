class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.2.1",
      revision: "91733be3109e5a5000b750939e5748433c78cfcf"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4be4d711deb728156cb50fd2b5339ce0656f80e9042753562aba2ab88624abb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ea6c64e48beba47eb34b0ffde2e70a6ffd4f5a6e7056368852f75daacb4236e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "386726c8ba46ba423523347d1ca67011a9e7a0e107f4cca8d5fe268351dcbc10"
    sha256 cellar: :any_skip_relocation, sonoma:        "44d192119cf5a0b4aee8962a05f869ba9576d6a03b4c4082fd137c6323006e77"
    sha256 cellar: :any_skip_relocation, ventura:       "36c50ccfea48b3b1d975f9f45c4961be11335c115659662e6105c2df2af7d032"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1e397cdfe9a93c66a5ae5b2309788efe9dd58c3d3df8935936821b9358c80c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02e96b1a8f153d10fa2f687911a4385d710d8c28a79af49232730f4c04701a46"
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
