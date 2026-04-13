class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https://github.com/alebeck/boring"
  url "https://github.com/alebeck/boring/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "3d256a1b9bc8af30782377fafd8fa04c9d7d5bd8141b7a66ededfcd551876a76"
  license "MIT"
  head "https://github.com/alebeck/boring.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82d7a181b1bcb7115556412c386c6618cd0008c9d0f29d57797765651544e2c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82d7a181b1bcb7115556412c386c6618cd0008c9d0f29d57797765651544e2c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82d7a181b1bcb7115556412c386c6618cd0008c9d0f29d57797765651544e2c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "46b81c339e326c67b686284c304b3813783cef478e7f17ef3d5fdf90cbff8d25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a76d714a17e63ca3cd1edc43ddad69dc984a419d4eb4809f8bfd3cd55283b0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7aca59fda3df3f2d38b1e6b3d790abaa95aefe4476235929a29717ebb0f29cf2"
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
