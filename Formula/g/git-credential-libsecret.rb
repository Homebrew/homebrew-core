class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.44.0.tar.xz"
  sha256 "e358738dcb5b5ea340ce900a0015c03ae86e804e7ff64e47aa4631ddee681de3"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "346e0772b92610cebc9fb58a1f87fc64af9f0ac64bda6e86298cde451d31394d"
    sha256 cellar: :any,                 arm64_ventura:  "b3f66c5e6a905ba341931b74c6642819142a6bf175efcd88225ca483ccec4d7a"
    sha256 cellar: :any,                 arm64_monterey: "472ebd3a2f5db250acdd180bc1d7116e04b8906d65fc4833efef70c262b52813"
    sha256 cellar: :any,                 sonoma:         "f6444c6601aa54dc0a58605c1186e555baece4ea52f3b037ad00d11076d635d5"
    sha256 cellar: :any,                 ventura:        "687ecea68e319e870e61cf7ebd50b17d5059f5a9e0649e0491994939b366aae5"
    sha256 cellar: :any,                 monterey:       "5438eb0baa3fe33de69b4e207c7767d204dcb350e5ebd327dc6ad7b05f056ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17ffe448c0ea1875a195f8d73f13a892561c764edd221ad5e19acc25798476c9"
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
