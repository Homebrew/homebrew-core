class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.5.0",
      revision: "bcbb6036ec2b747bceb98c7706ce9b974faa1b23"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89e9bc7dcea945da0e0ff4dc7e28523f7da1e01c6649eb02c1780a84d5174b21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27dc1a886023dee99877fe1948c3fd60f96a366c764a0503a94532562904e827"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "464754315198a0e6a5460d9681ef35772c62c12bf9dfa2cc8dbc0a24a4a6ca83"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3ef2ee2c95ce7b8d9c86ff60fe91652ad63a122f2e29968070647b78f508d46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e85e3ebc1c0a609aa4a9aebdf7dc6756af61f642c7721712e2692bb9e506f0c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bbdb545d3e56f73602e5955721213206b4e36fad01f1abbc4d95b2d5961a4d6"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build # failed to build with node 23, https://github.com/openbao/openbao/issues/731
  depends_on "yarn" => :build

  conflicts_with "bao", because: "both install `bao` binaries"

  def install
    # Build ui assets
    cd "ui" do
      ENV.prepend_path "PATH", Formula["node@22"].opt_libexec/"bin" # for npm
      system "yarn", "install", "--immutable"
      system "yarn", "build"
    end

    # Bootstrap go modules
    system "go", "generate", "-tags", "tools", "tools/tools.go"

    ldflags = %W[
      -s -w
      -X github.com/openbao/openbao/version.fullVersion=#{version}
      -X github.com/openbao/openbao/version.GitCommit=#{Utils.git_head}
      -X github.com/openbao/openbao/version.BuildDate=#{time.iso8601}
    ]
    tags = %w[testonly ui]
    system "go", "build", *std_go_args(ldflags:, tags:, output: bin/"bao")
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
