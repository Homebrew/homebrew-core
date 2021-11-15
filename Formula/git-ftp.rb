class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/"
  url "https://github.com/git-ftp/git-ftp/archive/1.6.0.tar.gz"
  sha256 "088b58d66c420e5eddc51327caec8dcbe8bddae557c308aa739231ed0490db01"
  license "GPL-3.0"
  revision 1
  head "https://github.com/git-ftp/git-ftp.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bfb0d715a2d24fec7f659746d95b14270830b6b3bf838a6d822ee654ef92bf87"
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
