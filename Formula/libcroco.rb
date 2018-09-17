class Libcroco < Formula
  desc "CSS parsing and manipulation toolkit for GNOME"
  homepage "http://www.linuxfromscratch.org/blfs/view/svn/general/libcroco.html"
  url "https://download.gnome.org/sources/libcroco/0.6/libcroco-0.6.12.tar.xz"
  sha256 "ddc4b5546c9fb4280a5017e2707fbd4839034ed1aba5b7d4372212f34f84f860"

  bottle do
    cellar :any
    sha256 "af3b14a1519dbc7b5bd979997df77ef3152f3575b6257b4f35177abc66fa5d28" => :mojave
    sha256 "0bf41b44e72e39031c1ece76c12b20dc8bc566931c87baa484787c478f5fe4b7" => :high_sierra
    sha256 "26530657c9133fb47b9749889603507bc493cb85e4a61818014a1939e3cbd692" => :sierra
    sha256 "2e8e7dfb8acc4e79089f3409a4a4772ec0b243e1e773070d4e8323acb939e668" => :el_capitan
    sha256 "46e3c7e47448859863644d50ac6d940a19a1bfd7f5a99d4d753e4e3885654767" => :yosemite
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
