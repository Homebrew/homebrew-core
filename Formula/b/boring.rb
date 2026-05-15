class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https://github.com/alebeck/boring"
  url "https://github.com/alebeck/boring/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "c74a771e98750bcd745e282d29dbbd0cc9282adc9674e0ff44381ab2a46dae17"
  license "MIT"
  head "https://github.com/alebeck/boring.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2384dc6773cf751772120eda88d4560031950d4a1352919543277214c0b008d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2384dc6773cf751772120eda88d4560031950d4a1352919543277214c0b008d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2384dc6773cf751772120eda88d4560031950d4a1352919543277214c0b008d"
    sha256 cellar: :any_skip_relocation, sonoma:        "dea86e35c0c2c6705dc7c95bf7d3030c28dea712ee494d8136083a99ad0edcd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42d37ae685cb3c766845846486a22afb63a828d5805d0229b8fa779051f053d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1801f7f39c1acb1b5fb941fee2e38eb7e06d465e5e59508768cd0e8d3a03a15"
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
