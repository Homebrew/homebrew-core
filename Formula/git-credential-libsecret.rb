class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.38.0.tar.xz"
  sha256 "923eade26b1814de78d06bda8e0a9f5da8b7c4b304b3f9050ffb464f0310320a"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6992aff0aa77859e90e437df6847911234de6df6ebd6681273490bcdffcefc36"
    sha256 cellar: :any,                 arm64_big_sur:  "cca356a297eb0c622df34b8328ce10bce5e298d56a8595452213773552b2c9eb"
    sha256 cellar: :any,                 monterey:       "5fae0716b65b11de4bdf251fc91fe2a44f4097f5bd7003b06b701873c2ad4504"
    sha256 cellar: :any,                 big_sur:        "be738e8cb519560d5d43c29065f0de7dd7af3ba5835dc9ec0d57349140a2e8f9"
    sha256 cellar: :any,                 catalina:       "1cda59c93db7ccd00ecdfcb03b80f84e97d71f5cb93b3b6787bd8f40df1d4fe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9f3d924cf8e11f3d3103ef369b9c26dc16381ff3d9e41c0dc6ee8d31bce582d"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsecret"

  def install
    cd "contrib/credential/libsecret" do
      system "make"
      bin.install "git-credential-libsecret"
    end
  end

  test do
    input = <<~EOS
      protocol=https
      username=Homebrew
      password=123
    EOS
    output = <<~EOS
      username=Homebrew
      password=123
    EOS
    assert_equal output, pipe_output("#{bin}/git-credential-libsecret get", input, 1)
  end
end
