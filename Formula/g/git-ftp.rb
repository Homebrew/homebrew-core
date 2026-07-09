class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/"
  url "https://github.com/git-ftp/git-ftp/archive/refs/tags/1.6.0.tar.gz"
  sha256 "088b58d66c420e5eddc51327caec8dcbe8bddae557c308aa739231ed0490db01"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/git-ftp/git-ftp.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "95470631e72758db4f8eb07739a78f6265c09bcf41da6f69bd8c701f02bed360"
  end

  depends_on "pandoc" => :build
  depends_on "curl"
  depends_on "libssh2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
    system "make", "-C", "man", "man"
    man1.install "man/git-ftp.1"
  end

  test do
    system bin/"git-ftp", "--help"
  end
end
