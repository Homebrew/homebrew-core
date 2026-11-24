class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https://alebeck.github.io/boring/"
  url "https://github.com/alebeck/boring/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "6e8682e046de4d8ce2b034c28923810eab932fd0a6bce24bed9ee259a1603fca"
  license "MIT"
  head "https://github.com/alebeck/boring.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    manifest_sha256 "48411594d5aab6563cd708b3482bbaba06b11abf4c8501b19fc79ed9be9a5842"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ca4c39fc26801dae4cfe6ed3b724c761cdd02d56847c4526bfa89e53201e93bd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ca4c39fc26801dae4cfe6ed3b724c761cdd02d56847c4526bfa89e53201e93bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ca4c39fc26801dae4cfe6ed3b724c761cdd02d56847c4526bfa89e53201e93bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "71efcc65b4eecad9b1f15651c6c1e20f407d430e5253c96c1aad00d159491dde"
    sha256 cellar: :any,                 x86_64_linux:      "e8b3e5b0209e3b3a82678717f6639ee0fe1a284978ed37d892049d1acbb9363a"
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
