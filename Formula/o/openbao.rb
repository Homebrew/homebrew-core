class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.0.2",
      revision: "d7abf404f9f928a64b53fa2ff9192e00a9449b0a"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62362d1dc6cb0a349fa366b8030a721a02f36f10749df9dd9daeffe9dff705cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "580d3d675ab691f7e77b42fdc51002986d50ddfd23c651bf1c02de4cdc025e78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c200c2f1ad16a473b92d4e9f4a625768b93dcaca6d5cb2358fe30586b27c9024"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d252649f081e0a679217f7ea50464f65901d3946356fac5fd3ae571bd8d61d8"
    sha256 cellar: :any_skip_relocation, ventura:       "299e3a653200ff5b7bcd45e7f2c2fd3738a13d66c6d60871505e0174f69713ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e1c9912a430bb581bc64ae59cdb39ebbac486fab2c3f27bcfe1a383a261d5b3"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  uses_from_macos "curl" => :test

  conflicts_with "bao", because: "both install `bao` binaries"

  def install
    ENV.prepend_path "PATH", Formula["node"].opt_libexec/"bin" # for npm
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

    pid = fork { exec bin/"bao", "server", "-dev" }
    sleep 5
    system bin/"bao", "status"
    # Check the ui was properly embedded
    assert_match "User-agent", shell_output("curl #{addr}/robots.txt")
    Process.kill("TERM", pid)
  end
end
