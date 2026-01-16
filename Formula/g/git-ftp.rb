class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/"
  url "https://github.com/git-ftp/git-ftp/archive/refs/tags/1.6.0.tar.gz"
  sha256 "088b58d66c420e5eddc51327caec8dcbe8bddae557c308aa739231ed0490db01"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/git-ftp/git-ftp.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "74119c0541aae24192ccff0a849869feb988a02de848a93476da5d1c1ad46fba"
  end

  depends_on "pandoc" => :build
  depends_on "curl"
  depends_on "libssh2"

  uses_from_macos "zlib"

  def install
    system "make", "prefix=#{prefix}", "install"
    system "make", "-C", "man", "man"
    man1.install "man/git-ftp.1"
  end

  test do
    system bin/"git-ftp", "--help"
  end
end
