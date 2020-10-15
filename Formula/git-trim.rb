class GitTrim < Formula
  desc "Trim your git remote tracking branches that are merged or gone"
  homepage "https://github.com/foriequal0/git-trim"
  url "https://github.com/foriequal0/git-trim/archive/v0.4.1.tar.gz"
  sha256 "c4b406daefb3753646314d967be99122dace2d5f7dbbceeb360ced9718961b36"
  license "MIT"

  bottle do
    cellar :any
    sha256 "fa0efe7a38c2969462f0c5799a988ffd08e07adfc0f92a19fe73d8d239b42a36" => :catalina
    sha256 "857c43fb364a7c2a341d818072e98f84213f2315d6b0379a41620fb106512c78" => :mojave
    sha256 "9e92f027e58fca0f28f0a6db3740d79e97858318e3077db1611b2fde833d14d5" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/git-trim.man" => "git-trim.1"
  end

  test do
    system "git", "clone", "https://github.com/foriequal0/git-trim"
    Dir.chdir("git-trim")
    system "git", "branch", "brew-test"
    assert_match "brew-test", shell_output("git trim")
  end
end
