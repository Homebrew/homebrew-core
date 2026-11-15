class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https://alebeck.github.io/boring/"
  url "https://github.com/alebeck/boring/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "2e9b07032a242d7bd3ff92a712c6ae04875afc9f99dcb72f649dde4925aa119f"
  license "MIT"
  head "https://github.com/alebeck/boring.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b47dd1aa5e28c3f6a77c369a4635ee169c3d7d8835f278fdc8311bb6c479e54b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b47dd1aa5e28c3f6a77c369a4635ee169c3d7d8835f278fdc8311bb6c479e54b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b47dd1aa5e28c3f6a77c369a4635ee169c3d7d8835f278fdc8311bb6c479e54b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ac883f49524f39e2d56711f8fd5a8a3d2c730d8f0dca9dcc89c8963d664203bd"
    sha256 cellar: :any,                 x86_64_linux:      "c7fedff28f89686921a73289dd5e639df6248e7704781338e3de5cf483c557cf"
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
