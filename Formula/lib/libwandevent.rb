class Libwandevent < Formula
  desc "API for developing event-driven programs"
  homepage "https://web.archive.org/web/20220615162419/https://research.wand.net.nz/software/libwandevent.php"
  url "https://web.archive.org/web/20220126151045/https://research.wand.net.nz/software/libwandevent/libwandevent-3.0.2.tar.gz"
  sha256 "48fa09918ff94f6249519118af735352e2119dc4f9b736c861ef35d59466644a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1520337069b3cc6c78f21ef8f4d0fe07b74ef7589f7f0cb976b0c9fde7089d0d"
    sha256 cellar: :any,                 arm64_monterey: "1cd49d09ac626760b7aee5ed8deee8d01338880d89ca3ee05077a16b7ddae100"
    sha256 cellar: :any,                 arm64_big_sur:  "57f916a1558f5b44462c12c98260ab27d0b4c5dd6b9df9502d9d8d19a480e437"
    sha256 cellar: :any,                 sonoma:         "5cdda4b182fed4bc2d7da9e03105ad4ea17e4b64d4fda748d558e480fa20e077"
    sha256 cellar: :any,                 monterey:       "3a15bfd5275a5edfa5ba3bcff1a6d3f238477386fef790bd1c44c7a5447944d5"
    sha256 cellar: :any,                 big_sur:        "651aea239dab48e29f473c5a181f9dad8420350672a99e063419974599e26674"
    sha256 cellar: :any,                 catalina:       "f175ecabb18921593ddd08bbd0b2aaa5e0a24c85d2964be230cd3a1f0ede22ee"
    sha256 cellar: :any,                 mojave:         "1e1db4ade4de58ab9ca1f0545d91537b935b65e062d99737c288dd059a17da8e"
    sha256 cellar: :any,                 high_sierra:    "7593e96a9e76e4b67fa3851a3491c8d7cbd458ad53ff65b3a34b64e2f697e75b"
    sha256 cellar: :any,                 sierra:         "e4b00ade9387b8fdccf72bbe9edd0e334c69f23597f85dd1e6da02088703c286"
    sha256 cellar: :any,                 el_capitan:     "f1459d39284b520c17443c6bef5ccb641dfe1e20266a4f34071f6a87cd9669e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa30ff4a09850d6c0611845c6a36c981a8648d1fb47afe428d09f28fa7dfa36f"
  end

  disable! date: "2024-02-21", because: :repo_removed

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <sys/time.h>
      #include <libwandevent.h>

      int main() {
        wand_event_init();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lwandevent", "-o", "test"
    system "./test"
  end
end
