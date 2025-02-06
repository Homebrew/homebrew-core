class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.1.1",
      revision: "17509a8c5e0af4ff921d4e70b06224397c44dd74"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bd8c6564e95162b461615825d30e98b68f2244768802c7989ffecefb8afcc8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ff8fbcf26552c95f46edb600066f634d7b3d9865256f1e9a67eb90b00cc5ce1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de38b4f048d95a7fb0c140888e59964c75348e927515b2219566c5e12c0c5398"
    sha256 cellar: :any_skip_relocation, sonoma:        "3690719b13b067d4698b3515764cbddeed734ffc46d5553969b067a0b18cc7df"
    sha256 cellar: :any_skip_relocation, ventura:       "89dc72dd74ee3b8ad94c2c0f97350ea4a43386299f9bc3a078519b71c82dbbaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a74821942911310de90877a0209c766dd9fcb691a24570d81441476a9f51470"
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
