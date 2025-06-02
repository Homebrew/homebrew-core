class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.2.2",
      revision: "8c0322c0423231836a1432fdad29dc2e99640da9"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "941565bdfa53e906e8a995e0a43c15e991857027ef1815de406e028ee9002833"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7f9a7ee02e583f70b3876ffdf869884d93d50f7cfae1cc91980c383e9259fc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02b9f76e6d7a923769370d0f5f5a68b9306fe0caa83af230bb404befb8c5cf08"
    sha256 cellar: :any_skip_relocation, sonoma:        "15e58ba93d2080919011b2d0605e0a4cda140fb51c304555f5f7fee3bea77a2b"
    sha256 cellar: :any_skip_relocation, ventura:       "3d02dfe624dcfaccc8974373569afc300a0a7c912795cc57eb84057df2db13c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3c621968622f1ce1d153b713c3e7182589381d204ea3a8672d0f523e2505589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e2dc436688c930ef4b54165560acb2d7e1acfebcf31f26392270ed2dbd45c4b"
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
