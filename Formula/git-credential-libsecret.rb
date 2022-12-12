class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.39.0.tar.xz"
  sha256 "ba199b13fb5a99ca3dec917b0bd736bc0eb5a9df87737d435eddfdf10d69265b"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9853c35dd94c17f644ede31372bf3b67a9b46ea8919ecb78d0d4ac8f4f6b4e22"
    sha256 cellar: :any,                 arm64_monterey: "6355c9f63f919ede11c0e2ed617d5acd9341129d2cc21d31026430d3c59091b8"
    sha256 cellar: :any,                 arm64_big_sur:  "b5081d490476d3f73b3dd0b04575c95ccb5a3706c78f7174df4fee8da33336fb"
    sha256 cellar: :any,                 ventura:        "e3ef9d0a2d64f08f78f203c761bb1115b465c41b56e985eaab225cc6a7e957a1"
    sha256 cellar: :any,                 monterey:       "11467399b367909eea858f2cb55f36dd2e73a0b774684ba94dac757d398a0648"
    sha256 cellar: :any,                 big_sur:        "b1e07a8627e32e7f82cd3f4273f80935940b9f57c115ce4de3a2f52d7c6ef767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb1ae7f19e731459f504c072c318be6903f6acf7cd207cefdfebad7648f4db7f"
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
