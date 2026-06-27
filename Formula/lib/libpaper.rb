class Libpaper < Formula
  desc "Library for handling paper characteristics"
  homepage "https://github.com/rrthomas/libpaper"
  url "https://github.com/rrthomas/libpaper/releases/download/v2.2.8/libpaper-2.2.8.tar.gz"
  sha256 "1e330571690191874eca415ec76889dd11bab9887a2302d6a3665cd081c4d77b"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256               arm64_tahoe:   "e6500bd1b2096cc88b3289610bd7a651a2ec40e1749b549e09e8f74ca20cc125"
    sha256               arm64_sequoia: "39b2f9ec39466dbc44bec4b7dad83c5c2f83f1aa9689a23e3b2f92f119daba94"
    sha256               arm64_sonoma:  "9cdf695868346e48cadfcf919bde607c247abc89ffa536fe4fc8b68ceeac8c45"
    sha256 cellar: :any, sonoma:        "24d77cb51ff26f143c4f8dcafb5df6fa825ee6b12dde52a82770577475b23716"
    sha256               arm64_linux:   "27009b7f07bd076b9b1f1f100b6753e205cb25f6e8b81dddb9449c6a4481a42d"
    sha256               x86_64_linux:  "a4c43ea9adcaf5da52727b419385b518ef9c8d16e7a4203435eeea3bef874dea"
  end

  depends_on "help2man" => :build

  def install
    system "./configure", *std_configure_args, "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    assert_match "A4: 210x297 mm", shell_output("#{bin}/paper --all")
    assert_match "paper #{version}", shell_output("#{bin}/paper --version")

    (testpath/"test.c").write <<~C
      #include <paper.h>
      int main()
      {
        enum paper_unit unit;
        int ret = paperinit();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpaper", "-o", "test"
    system "./test"
  end
end
