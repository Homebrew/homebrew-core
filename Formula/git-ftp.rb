class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/"
  url "https://github.com/git-ftp/git-ftp/archive/1.6.0.tar.gz"
  sha256 "088b58d66c420e5eddc51327caec8dcbe8bddae557c308aa739231ed0490db01"
  license "GPL-3.0"
  revision 1
  head "https://github.com/git-ftp/git-ftp.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "22f0e6b0a0c16aa110711333e1a44b77d65fe851049db51fb200f33a2e2be534"
    sha256 cellar: :any,                 big_sur:       "2e3d8573c71ae26fdac0d0d8952e625b5a14d90118a6a413604eac8c3a6f6eb6"
    sha256 cellar: :any,                 catalina:      "0a61ca11e69370dfecfd3c82d6d03aeec377bf9db660658403556ea71b84bae0"
    sha256 cellar: :any,                 mojave:        "f878c4015697794bb8b2c3f034a167b750d3871c0d320d903536128f01880ca2"
    sha256 cellar: :any,                 high_sierra:   "63c8b94fd89eb635d8c2056efdf933de45dca7fdb04793b620750f8b338fbb88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb75d2375209ab69ec41dec62ec6715ebc0ba21f442313a2a6173df976c418ab"
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
