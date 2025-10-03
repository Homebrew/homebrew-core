class Gowall < Formula
  desc "Tool to convert a Wallpaper's color scheme / palette"
  homepage "https://achno.github.io/gowall-docs/"
  url "https://github.com/Achno/gowall/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "31992b7895211310301ca169bcc98305a1971221aa5d718033be3a45512ca9a4"
  license "MIT"
  head "https://github.com/Achno/gowall.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1ec11e01767a4c46928c76c1fdd08957a0e43d452b421b4438ec91ad49c9993"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34dc908f5f3d79cbec77054867e82ef3df922edd34d5911f4682962b8554ac28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39ec1eb39a2b1c802bd77fe3cd726749e958387affdc9aafc1df9d3632a15c08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05ac7c037fe03766da5ddbd174b7269cd15a3776e8ea24a59a4867a136e79be0"
    sha256 cellar: :any_skip_relocation, sonoma:        "253286c45351373ed0553a5b7112a66d0357ba19ac7f10df563580dce782cfb1"
    sha256 cellar: :any_skip_relocation, ventura:       "e1eaca5511b100652751f38a3aad0d706dc2b4c1c68bc43b6a14493fb34cb9ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "417047ad8f54043eaa06f701889b7260e15bc8819a886232f6b16cd21f79b056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d366964c9da1cde599496cf92ef070bdffb9cbf1e71c96c1dedffe02af05e916"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"gowall", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gowall --version")

    assert_match "arcdark", shell_output("#{bin}/gowall list")

    system bin/"gowall", "extract", test_fixtures("test.jpg")
  end
end
