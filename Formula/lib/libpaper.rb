class Libpaper < Formula
  desc "Library for handling paper characteristics"
  homepage "https://github.com/rrthomas/libpaper"
  url "https://github.com/rrthomas/libpaper/releases/download/v2.1.1/libpaper-2.1.1.tar.gz"
  sha256 "a4e1297b69b9fd1054ee7f5bcc55f4d56da152d41d2eabdf18727a9cddc1f402"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "d96883b99c378406969e7af701e3c5f0e00f05ec55926d83bbe17622b5e8b222"
    sha256 arm64_ventura:  "528086cb278201eb1917007622a51c4a053157d63f6c0cad0c379781037d0090"
    sha256 arm64_monterey: "5003e022225bfc6a9b40e4c67897048eeab600b3ad133074eeea0a2c676806c3"
    sha256 arm64_big_sur:  "ff4a49f2f4c3898310616cc7211e762722b50e78971636dd5ab98666a2ca199b"
    sha256 sonoma:         "22a25aa0090a46892eeeea05aa2f081cb5232130f7aac63cd35a9ca2b166dead"
    sha256 ventura:        "16e918dde508544ec9ae15b824e85fd3f5669faffb4313dba7b6be5271587193"
    sha256 monterey:       "efc5d276ba267e5103d7e09fd4341a75dafa967ee997fc7b6f13347f3d4f07c4"
    sha256 big_sur:        "671069a7e3b96d15a012cbd50a0ece1344fbd36a7de8350dd721dc1818a38715"
    sha256 x86_64_linux:   "921951d3feb1258811293c10f3a1d8622cd891f8979a8fd23d2513dd1124041a"
  end

  depends_on "help2man" => :build

  def install
    system "./configure", *std_configure_args, "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    assert_match "A4: 210x297 mm", shell_output("#{bin}/paper --all")
    assert_match "paper #{version}", shell_output("#{bin}/paper --version")

    (testpath/"test.c").write <<~EOS
      #include <paper.h>
      int main()
      {
        enum paper_unit unit;
        int ret = paperinit();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpaper", "-o", "test"
    system "./test"
  end
end
