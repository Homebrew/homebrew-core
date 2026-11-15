class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.7.2",
      revision: "9e0a0d3c3504a0a00b45e61355afac5e35c78379"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e99c51b24fa4cb954a1a8a56a75d69dde29d8d4534dd77599d10ea957b8ea531"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ebaf74ba3e60cb01a1fd222bc1df28cae9b625abbc7cea057d682d509c73692b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b19fe229a3de55a7f7d24f71b6878edd8d49f49c7bfe2867a0339401937763c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3673e61161c5455b2528aae57e45bd1fb901b9686eb50879b69cd3f7c494fbf9"
    sha256 cellar: :any,                 x86_64_linux:      "e36c742ee7f873bd29cdd6757d54ae7ed105390edcccba5099ba4934c437a2ff"
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
