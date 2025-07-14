class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.3.1",
      revision: "e3cdbbde8eb48fb7ae92b1d34afb63012e805233"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f843906679903c21a0c35d638a6dcca92f0b7e3dc316bb0d85f93ea452e619cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94e7637c77a92f68298d6d0d749ac595a773c487061573d180c446fa70e987be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ea071b41242875fcae6c5400907b6dccc47764c148a44d41d9f21cae0877f77"
    sha256 cellar: :any_skip_relocation, sonoma:        "93bd2c3b0322ffa33609323441f33dbdab2f6d7feeb0f43af55c9b72549e8b59"
    sha256 cellar: :any_skip_relocation, ventura:       "31ad64268a5054f74109ebd7f13f369485b1644db52328a677797e22215e4d4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b497cacf9142908e7e336c4fba7cd2a8274dc427a4b43202e1d25b5f72a57a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fee2e9e46c465fb69d283d79e86b66fe922327d360dcd3a6d1d7dd990d77144d"
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
