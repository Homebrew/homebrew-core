class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/refs/tags/v2.36.0.tar.gz"
  sha256 "f9be77f9c6a4abc2e14bcdf55057eb209f1ab7bda50b78dcd9ab07533ea4a58e"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1144c5c33857cf52c5fcfc19490321cf0dffa03589703bb5650e7b44afd4df7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac5bea546ba6025ede2b38465a53a160b2f618ce2fd7d2fadcd03680ba973370"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0598afe23f9efef6eb2ade072006047264ed2061f58804152647904601236603"
    sha256 cellar: :any_skip_relocation, sonoma:         "67239d26c6106d0c6354cb29785a91a8c2d528a1d58c86886c9639a3b31819af"
    sha256 cellar: :any_skip_relocation, ventura:        "ea9a966e6ccf2e72dc2472bcf7387a4e8b6a889433a2d7cf2eb135e542a15fd2"
    sha256 cellar: :any_skip_relocation, monterey:       "ef8805e292713e9dc027091a53520423749c7013b35743b271685a5b34017bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80374980e4d7f428feb3fc8e3ed42d61b1a5b72ac9ecbf37011a3930ce655cd7"
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
