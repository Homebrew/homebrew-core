class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.4.4",
      revision: "4bfd70723d4f9b82be00e87b8c018ac661dd9b99"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8999fa214ae6d762b4a220a4f50962446163fe41b1fee27b219a24654efa5397"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f68a8e8b14b413aa61647add948f8012222f7b11a33be605bfaf62c1610fac79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82e7b1d677857025887ba8d7e27295705b53589927a88b1cfcd671ca5d064d1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "170749bba9981bcee3d88ce4e73fc6a4edbcd22c0d0abccc580d548e2f44b99e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e16e7abfa3a9107c25dd26b0d5d0361bd1e25278f75e5ab96a1235d012338c29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fde949f5478f711a4a67dfaf406e3081b6cec60f42e789f53fdf1cb1cad779f"
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
