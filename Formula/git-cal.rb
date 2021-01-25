class GitCal < Formula
  desc "GitHub-like contributions calendar but on the command-line"
  homepage "https://github.com/k4rthik/git-cal"
  url "https://github.com/k4rthik/git-cal/archive/v0.9.1.tar.gz"
  sha256 "783fa73197b349a51d90670480a750b063c97e5779a5231fe046315af0a946cd"
  license "MIT"
  revision 1
  head "https://github.com/k4rthik/git-cal.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1d191bdf9da21ef2dbe3eeb3909fbf738df652931b5ee9876b9868b429644899" => :big_sur
    sha256 "d2100e367528b52d5bf60d1e85687908e154fc8f831ef7bd29862b3bc899395c" => :arm64_big_sur
    sha256 "ee5e258bbc598978be1d2e3e3220c28b7ef1ff4d7e5a34bdcc852107f68b5f67" => :catalina
    sha256 "80bbebc06dc4f05e6aa34324276650f303a714efe857e72f67861d7cf9194451" => :mojave
  end

  def install
    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}", "INSTALLSITEMAN1DIR=#{man1}"
    system "make"
    system "make", "install"
  end

  test do
    system "git", "init"
    (testpath/"Hello").write "Hello World!"
    system "git", "add", "Hello"
    system "git", "commit", "-a", "-m", "Initial Commit"
    system bin/"git-cal"
  end
end
