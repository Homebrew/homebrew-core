class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.7.3",
      revision: "0439ef5812538733afb277b4445a54706edc1db7"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "67f35bef192c115a24aad42ad6b8495430428737b4ed452a5f7173bc6c87abb4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "592c8060f53241c352de6a224bd0930c196d641723221d0935f486fdc4b8405d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "05b6db8ceddaf43f039e38298bfd30813952b464ebc80c7902e5cb2d23301f3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "41ee6c6cdb7e8b0dd6645a8e3f59ea4d64715b84a874a9fd5c4a9bee6bce5d46"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4bc1d1c7de0df09fd922a02fd22010c2f7266c8bd918a6f5acd250257196b755"
    sha256 cellar: :any,                 x86_64_linux:      "ad5fbe44837705a96d55b2cdd3a4dae90e5ee7631782af42b34b8090c8362220"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  conflicts_with "bao", because: "both install `bao` binaries"

  # `test do` block runs a local server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
    cd "ui" do
      # Prevent pnpm from downloading another copy due to `packageManager` field
      (buildpath/"ui/pnpm-workspace.yaml").append_lines "managePackageManagerVersions: false"
      system "pnpm", "install", "--frozen-lockfile"
    end
  end

  def install
    # Build ui assets
    # FIXME: Poyfill to restore `util.isRegExp` for node 23+: https://github.com/openbao/openbao/issues/731
    polyfill = <<~JS.chomp.gsub("\n", "; ")
      import u from 'util'
      u.isRegExp ??= v => Object.prototype.toString.call(v) === '[object RegExp]'
    JS
    ENV["NODE_OPTIONS"] = "--import \"data:text/javascript,#{polyfill}\""

    cd "ui" do
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
