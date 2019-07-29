class Libcroco < Formula
  desc "CSS parsing and manipulation toolkit for GNOME"
  homepage "http://www.linuxfromscratch.org/blfs/view/svn/general/libcroco.html"
  url "https://download.gnome.org/sources/libcroco/0.6/libcroco-0.6.13.tar.xz"
  sha256 "767ec234ae7aa684695b3a735548224888132e063f92db585759b422570621d4"
  revision 1

  bottle do
    cellar :any
    sha256 "edf97f493296bfe01b2a8cfe156f1e8052e181bed6ea34cabaf18ed59ef28b17" => :mojave
    sha256 "f6e7d7d608dfcf6e57eaad77eef3cca27c15db0746e102f6dc33cccdd5a8a7bc" => :high_sierra
    sha256 "a95e3733bd72b789cc9a3cb9dfc9a92153939b984c4d1d47b8aa806e99e99552" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-Bsymbolic"
    system "make", "install"
  end

  test do
    (testpath/"test.css").write ".brew-pr { color: green }"
    assert_equal ".brew-pr {\n  color : green\n}",
      shell_output("#{bin}/csslint-0.6 test.css").chomp
  end
end
