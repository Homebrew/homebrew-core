class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.4.1",
      revision: "efb9efa12f550e8322f3cec040862355e966f565"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "060475e9b83c0f8f8998a58968e474383cc6e63474ef2500b659b995084a3840"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0187af89b44c05e2d4b8b2f7aa5def7be809714b0653d4b88be7c3758abe469"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "451485de8b54c0a0f01179e095aaf902a5697787099747d5a4e1223ca596bc9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7ddfb9c93aed50bc9c28369093d4fd574e564fbe50b9fef103ddd493d9b353d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cc85a4a44a91cfa108daa3a8b2c8982dec410d3526412ac93bed21064f88b0d"
    sha256 cellar: :any_skip_relocation, ventura:       "bd2f02ddd4978101e66757f81f426c07572e54f2d199d3824454bdd7eb64f584"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cd91f18c484e28033cb3994103aac088138f68c753fe554f4069ec9f93b8af5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7f3dad63941d3a397dbd76fa2af0db2dbf1569c757fbd68726bd4a78b122bcf"
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
