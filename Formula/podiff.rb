class Podiff < Formula
  desc "Compare textual information in two PO files"
  homepage "https://puszcza.gnu.org.ua/software/podiff/"
  url "https://download.gnu.org.ua/pub/release/podiff/podiff-1.2.tar.gz"
  sha256 "6902c10ceb9bb131d40cb2a7023ebb61df0ee7cf8abf1833129df65120244bd0"
  license "GPL-3.0"

  livecheck do
    url "https://download.gnu.org.ua/pub/release/podiff/"
    regex(/href=.*?podiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cdda50f296e87f84f828d09777f90217c98ca4578a00b09307df9dcd830424c2" => :catalina
    sha256 "20e29ef344ca1da47dff379a12290150de1540338d49d00043a2093f3a22a6fa" => :mojave
    sha256 "71b8f6e4b7935a26b50e32805036593d4fd20e24d4de73023a423a6889e72752" => :high_sierra
  end

  def install
    system "make"
    bin.install "podiff"
    man1.install "podiff.1"
  end

  def caveats
    <<~EOS
      To use with git, add this to your .git/config or global git config file:

        [diff "podiff"]
        command = #{HOMEBREW_PREFIX}/bin/podiff -D-u

      Then add the following line to the .gitattributes file in
      the directory with your PO files:

        *.po diff=podiff

      See `man podiff` for more information.
    EOS
  end

  test do
    system "#{bin}/podiff", "-v"
  end
end
