class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/refs/tags/v2.37.0.tar.gz"
  sha256 "527ca3aeaf6a565a0b058825748683ec5f5e199d5754466943c1f5c69a7d5bfe"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe36122c4b952f1939630827186e3d56453292d704cebf64f9452e34047cde72"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8c21e08d77963c2d12102aefe38f8c010c573b771ccf729ea438c40dddb7f3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d99911748b13cfd9ef91438cc18e27694ff0e1ac0264c3e2a5a6b59054f861e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "e399a7d0cff1731b888f82d6a25dd90f51ebc074c161ea839569a869c41d2a96"
    sha256 cellar: :any_skip_relocation, ventura:        "b676261b938d7b1d8476874218f8877d45b84a22b4441bed6bcb8b2797fa362f"
    sha256 cellar: :any_skip_relocation, monterey:       "18d60b84f3b2c85ff0ae2f36cbd6c23bb1edbbc4d30089bb0d47e9bcddbdcc8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16115dc18278d7cacd541bef82d162978379266daebbcb2359a97bc81481a738"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
