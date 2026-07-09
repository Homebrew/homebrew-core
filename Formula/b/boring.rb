class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https://alebeck.github.io/boring/"
  url "https://github.com/alebeck/boring/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "cd3acf4650385afe1136cfb8d31a5fa341adfb1baacc81b04436e87643c5684b"
  license "MIT"
  head "https://github.com/alebeck/boring.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4465b8e6a1c84d71815794f38416f4f2d40805498f819eb9583aa8cc9e939b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4465b8e6a1c84d71815794f38416f4f2d40805498f819eb9583aa8cc9e939b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4465b8e6a1c84d71815794f38416f4f2d40805498f819eb9583aa8cc9e939b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6ca44ab2dd4bf82558179fdba76cf2c0a783ac90f9b95e78f59a902c60f4aaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3024490e6a2aa46faee3aa41f4d0bce401b00be38fd35083dfb430cbddca78b3"
    sha256 cellar: :any,                 x86_64_linux:  "c475db8c8b1957008af45e0f1d9264d29bfe410f85b566ecedc487bd005de36c"
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
