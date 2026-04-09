class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.5.2",
      revision: "932fcf892eba8d646a9bfc58a59ea3b2475b17fa"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73414b30d081f3868162bb3751d6f479890697719d13fa8970462c7fd3acc14d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c339262b282d32645ddbcfba04f1dc876d4ae442da3e240ebf008eb1805cefc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4c297f5cc774d9c73003b6b7a6d1561f11576ac694c13668024a677c16d9dd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0930fd001710ee27e9f4521188eab4a646e651b99b09dbd6bb2a0d1648ab438c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e06475427672c4e0b6e66589e2e695cab95ac24375da79dd55bc22c44b0c106"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb08f3421b84c6e9a5ac7251804eb9b7c2a0ee45f6adee4d6c16fefb8eee49da"
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
