class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https://alebeck.github.io/boring/"
  url "https://github.com/alebeck/boring/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "ca1c6616ba9536b4d90f62e47c7b72bc7914d10fd5db2b14087b2774d29db0ca"
  license "MIT"
  head "https://github.com/alebeck/boring.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "752c597c1b0842381eaf28035689c765d676da6a73452685d7e7960bce7aaa3c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "752c597c1b0842381eaf28035689c765d676da6a73452685d7e7960bce7aaa3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "752c597c1b0842381eaf28035689c765d676da6a73452685d7e7960bce7aaa3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "66cb1b07605b88d91693d59619d979ad2a2b99398921acac75a7118fe8a2bf1a"
    sha256 cellar: :any,                 x86_64_linux:      "afed65ef59fe4106b69b7528770472c65869acb7d79cb404775b921977e0908e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/alebeck/boring/internal/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/boring"

    generate_completions_from_executable(bin/"boring", "--shell")
  end

  post_install_steps do
    terminate_process "boring", must_succeed: false
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/boring version")

    (testpath/(OS.linux? ? ".config/boring" : "")/".boring.toml").write <<~TOML
      [[tunnels]]
      name = "dev"
      local = "9000"
      remote = "localhost:9000"
      host = "dev-server"
    TOML

    # Keep the daemon socket inside testpath, the only place the test sandbox allows unix sockets
    ENV["BORING_SOCK"] = testpath/"boringd.sock"
    assert_match "dev   9000   ->  localhost:9000  dev-server", shell_output("#{bin}/boring list")
  end
end
