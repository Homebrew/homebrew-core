class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.5.3",
      revision: "988c88d7ef54b4d4581629b229488dfba5e085ba"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "709265cbcdd2462b8b6f57db4dc89e1cfbf0e5e1575c19147799f0742729cdcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed8a81d806011ffd841afbe2caf3995940274fa62a70a145ed8fd4ac3eb74839"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec80436ad0a759e580a0e3bef72ed3a1ea4da8699ca5aaade861ec3ca12894e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "39c7431935277b1f25de0ade7d9a274de2c75da187e5cc953dfe99cb1d7e3294"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e566c6ffa6c68658a0bfc820721d426e0bc479cb96cc608be396f95c4eed85a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6af60975b48e1ebec828394da43406d3e63cd275318e97d25a7d9036c51c74e"
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
