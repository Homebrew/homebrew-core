class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.35.0.tar.xz"
  sha256 "47e677b475226857ceece569fb6ded8b85838ede97ae1e01bd365ac32a468fc8"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "325c537b2356add3a081dd94df04b54fa455d1b14880fb5ee60ef8a6466251e0"
    sha256 cellar: :any,                 arm64_big_sur:  "d2fdc48030701940341dba921066f7e495d04281242140d5fea0bf88aff7eb05"
    sha256 cellar: :any,                 monterey:       "fd265ae60b58a27c2694a5563b0b41451618c8086dca7cbfa8f17e1b83c38dd6"
    sha256 cellar: :any,                 big_sur:        "77f0af9cf6828deb26ac6b132ab4a58fbee30235c18d1fdcb7eb1dfc2cf3ce30"
    sha256 cellar: :any,                 catalina:       "a3f0594d1df252acb8f63bb1f6ebc490a0c876228182f0da3d2a61b16fb5aedd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d106e9cae6cb88159ff31b60d2efa7bf278b417c2fcd1c17879acec7be5bfd55"
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
