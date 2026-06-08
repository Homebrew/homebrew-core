class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.5.4",
      revision: "4f6d47246a053375271a5fd8af85c3b75695aa46"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f55d117b1d9e73367b723c95744bad3942756808cda645463713d4fafb0c7dc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2361b14f5ba83b5dbdee4dc0928539ca98727d514a60e1f698a86dd3344d6527"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d68461e234cdac96e498c8c861b9013318fbab7829cfdcccd58475e58f727c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb13b47dabbf506f27c02da1d8cb2e5a71407137cbb781283fe710c0d3ed73bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "364141c428a18aa302985d5f2662a7b559b21e1c62670e6c7ffc18f51b7180b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed1ae28d6553a5b7dfc1d2041de24e403c742fb914abbd4d9844104413b4b133"
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
