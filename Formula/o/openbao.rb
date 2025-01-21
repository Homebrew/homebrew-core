class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.1.0",
      revision: "93609bf0c73a18dd81ac8c7d21b95cbde1e4887c"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "940577b0a16660eb3b8f2102b6136b1ad1b442e7de8fd07deab094d2a4c5429b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60c1e58b97bdd7b8a97ae5dd77928f4cdc793961fdb378a672f3254ae0c373df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf0e4be4db2c9ada9155742fa55dab94b2eeb33446da4a03a34b5e715ba644a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb2b837e679ab8a4fc0811f47ce491fe3ce300a99d129d3ad11500d1e18b720d"
    sha256 cellar: :any_skip_relocation, ventura:       "e40878ff92e9d146e9288c134815fdd6e9fe02cb8a34f9633b8d3abb595c909f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1920f697d2f763daeb299b7d0c33cd45f82fe862f42b9f4b8cb193aa58b3d5d"
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
