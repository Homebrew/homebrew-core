class Libpaper < Formula
  desc "Library for handling paper characteristics"
  homepage "https://github.com/rrthomas/libpaper"
  url "https://github.com/rrthomas/libpaper/releases/download/v2.2.4/libpaper-2.2.4.tar.gz"
  sha256 "985037a75829dcbab6e9a4b6651731848f4a1720e647f97d2155ee8e40c2ab38"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "786452152952325f3d77cf74404be6aeb41152e7c43616dbd184f47dbc60ec47"
    sha256 arm64_ventura:  "09ed918523282ef8f12ed2d4c4b9f350b631b5ce705ed2e84629517018f787bc"
    sha256 arm64_monterey: "38e63fb74451cbe22ebe873e8d00aeb985b92f6cc323ed21a3937f173840b79c"
    sha256 sonoma:         "77f5b39699369fa8889b75e639081f7ca3496ed294a6abf0e19e86afa688bafc"
    sha256 ventura:        "887b9b96124a28944912f83d144a1e0cd25910ba59c1240aa3b0eaf03498debe"
    sha256 monterey:       "1a0d53c805967b6324fd9ca7e90e322733c423238757f2f089fddbf896cce6ea"
    sha256 x86_64_linux:   "d0d6c406373d8014a6cbef56e21e32dac36bcce56ca85d20e31a60fd1944a079"
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
