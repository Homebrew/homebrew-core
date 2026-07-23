class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.6.1",
      revision: "ba7ad8861d0578cd4da4f7b9e5a6756d30484f8f"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2af509e6b4a72ac0da92b49f495ce0bd1fcf2c01469f30efcdb8950f2849cfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa1fbfb55dd911a70d4b76b1cbd7fb8ecab7581f296fa0e11fd25992d6b3664d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3be960e326ba9283e61ee6f60c1787548678c8a875b868ff0bba459360dbb8db"
    sha256 cellar: :any_skip_relocation, sonoma:        "427f48159edd8b97ccc33247db471da2b70840947e666615a7fb956857b6c127"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39518923d2d0e820af8f5b5aefa5d5031b7eb6d7c6da1f560a0694c4c9612a1e"
    sha256 cellar: :any,                 x86_64_linux:  "b5e200ad215659d639a39662425a8897100a4c3afbded77c920722a1e6bcc7f7"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build # failed to build with node 23, https://github.com/openbao/openbao/issues/731
  depends_on "pnpm" => :build

  conflicts_with "bao", because: "both install `bao` binaries"

  def install
    # Build ui assets
    cd "ui" do
      ENV.prepend_path "PATH", formula_opt_libexec("node@22")/"bin" # for pnpm
      # Prevent pnpm from downloading another copy due to `packageManager` field
      (buildpath/"ui/pnpm-workspace.yaml").append_lines "managePackageManagerVersions: false"
      system "pnpm", "install", "--frozen-lockfile"
      system "pnpm", "build"
    end

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
