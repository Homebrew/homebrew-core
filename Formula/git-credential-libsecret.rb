class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.36.1.tar.xz"
  sha256 "405d4a0ff6e818d1f12b3e92e1ac060f612adcb454f6299f70583058cb508370"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "599d86ca51e8597fc56529f470f1a9a08f1c69ddfa0512f6d2f0f4cd24175e07"
    sha256 cellar: :any,                 arm64_big_sur:  "c0d858d429da453d47161116b018bd47ac1f09a0eb7531bb99e7530b6f26bfc3"
    sha256 cellar: :any,                 monterey:       "2fba6310a2cb404f972e6e83333afc88c59c54ce0d13fea75811f0823d75054e"
    sha256 cellar: :any,                 big_sur:        "4b06188cd86f89b1bd5b9f6541d33c881b5bb3dbaeb0f3e81ecf71254389ee5c"
    sha256 cellar: :any,                 catalina:       "df7a75f52e7d50e9ccad710b3b8834efa5eb074524e934ab6ddcb8602b25f2cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8ada439143af23160ded71cf6d9ed17d7468eaf9934fd254b77aa99490126a5"
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
