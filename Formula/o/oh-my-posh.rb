class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.35.2.tar.gz"
  sha256 "1080f0126d07c99b28ce026b7838ef584e83f3f1ecfbf571d50c53d84a2803d3"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59d04f2d9ddbdc208d1460db98105fd4265bbc341e7bf1fa6a198c904cfefb59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf0326293f4e4accb02a80d0f5df8e039b4dc2648f455de4d7154e4193430361"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f09423fde7f9b00f1b04d8a0bb2aa291ff562ee589bacc588894d280bf439fd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "637e634887dacd472c6db64ac9caa8e7029254d7b245aef8c0e2f9df9e0d12f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8604be688b0995a1b772383f77672874d37fb918771931ba6df25478185ec8e"
    sha256 cellar: :any,                 x86_64_linux:  "3fe4cc944ce5a93043e2f967a77202cedcd082d84d61c0c1f7d908912660bd5a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end
