class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https://alebeck.github.io/boring/"
  url "https://github.com/alebeck/boring/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "89853728ad3c4c356a6ebb7762b0c54eaf1c78c14d03020c5aff971b3e3e44b8"
  license "MIT"
  head "https://github.com/alebeck/boring.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "616f20643a786357d39c17468c593cffa4aef194728ff8eef80dffda3c8fab67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "616f20643a786357d39c17468c593cffa4aef194728ff8eef80dffda3c8fab67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "616f20643a786357d39c17468c593cffa4aef194728ff8eef80dffda3c8fab67"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ab572db4b2760579cb30af1f155242b50a23270985800240cec43639dc5b48f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d14cfa7969a1b06ad4aed43ae9c4658eb42db4a58f7d691facc824d34612af73"
    sha256 cellar: :any,                 x86_64_linux:  "6577291b8eebeff42c6c271da54bc546e9edf3119bb36a2ecf04381a5d2012bf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/alebeck/boring/internal/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/boring"

    generate_completions_from_executable(bin/"boring", "--shell")
  end

  def post_install
    quiet_system "killall", "boring"
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

    assert_match "dev   9000   ->  localhost:9000  dev-server", shell_output("#{bin}/boring list")
  end
end
