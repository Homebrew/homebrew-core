class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.5.5",
      revision: "028992583c693c4de6350b8aa52ff85e30375a99"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1d08c3a7dcf17b211038a32481a80e5fb4a34fa09ceadace967fc02da87d933"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "939a15ee7ecafb5ef791910a224eea319d673a8bbaf5c48de96196a299216744"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "970fdb6c62538e9d5e5af3af9dc6c308db49b1604d77464820abe807a1ee1096"
    sha256 cellar: :any_skip_relocation, sonoma:        "12335d6f37abcc9ea7fb58f60dc3285282d44d0576310c88a00dec15bff59e6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93ca620ec6be2ef9e05edbd22d3ba05224962361d39f9179354eae3d698184b6"
    sha256 cellar: :any,                 x86_64_linux:  "f943e7dc2749d6ab7558f1608a24047616831bf0528db34cf9d4d1b873a74c96"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build # failed to build with node 23, https://github.com/openbao/openbao/issues/731
  depends_on "yarn" => :build

  conflicts_with "bao", because: "both install `bao` binaries"

  def install
    # Build ui assets
    cd "ui" do
      ENV.prepend_path "PATH", formula_opt_libexec("node@22")/"bin" # for npm
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
