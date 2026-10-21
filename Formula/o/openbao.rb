class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.7.1",
      revision: "a5db72cef75c24b920ade02065b18dd8eb666bac"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "156b7651c04dda0e21e81282b88ec15f27cc1384e288dc39ff06444e3d180960"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7d3283dfa0ab210155b18b54002bbb49aac0b064cfd5280408443fcccbc481fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e7e236a2c5afd9645dde9ca1df13fe72c8cf751450e29aac1de026a246576eef"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0c371c395061ffbb1951bd777a8065eb988cd84914f92c31ba15632a905038b2"
    sha256 cellar: :any,                 x86_64_linux:      "62a66068bfaa8ce67fbf6ce1e79310a6bec02852df4b99565424402c581442f7"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build # failed to build with node 23, https://github.com/openbao/openbao/issues/731
  depends_on "pnpm" => :build

  conflicts_with "bao", because: "both install `bao` binaries"

  # `test do` block runs a local server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
    cd "ui" do
      ENV.prepend_path "PATH", formula_opt_libexec("node@22")/"bin" # for pnpm
      # Prevent pnpm from downloading another copy due to `packageManager` field
      (buildpath/"ui/pnpm-workspace.yaml").append_lines "managePackageManagerVersions: false"
      system "pnpm", "install", "--frozen-lockfile"
    end
  end

  def install
    # Build ui assets
    cd "ui" do
      ENV.prepend_path "PATH", formula_opt_libexec("node@22")/"bin" # for pnpm
      system "pnpm", "--offline", "build"
    end

    ldflags = %W[
      -X github.com/openbao/openbao/v2/internal/version.fullVersion=#{version}
      -X github.com/openbao/openbao/v2/internal/version.GitCommit=#{Utils.git_head}
      -X github.com/openbao/openbao/v2/internal/version.CommitDate=#{time.iso8601}
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
    assert_match version.to_s, shell_output("#{bin}/bao version")

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
