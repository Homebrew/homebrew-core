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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d2100e367528b52d5bf60d1e85687908e154fc8f831ef7bd29862b3bc899395c"
    sha256 cellar: :any_skip_relocation, big_sur:       "1d191bdf9da21ef2dbe3eeb3909fbf738df652931b5ee9876b9868b429644899"
    sha256 cellar: :any_skip_relocation, catalina:      "ee5e258bbc598978be1d2e3e3220c28b7ef1ff4d7e5a34bdcc852107f68b5f67"
    sha256 cellar: :any_skip_relocation, mojave:        "80bbebc06dc4f05e6aa34324276650f303a714efe857e72f67861d7cf9194451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62d35c98bb021280c82914245ee51078760261e8ae8e877df3ddb7bfe8726231"
    sha256 cellar: :any_skip_relocation, all:           "04da9240bed39d9856a9f8615073a9117b17e5aedfaaf1c988627dfae35f9d95"
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
