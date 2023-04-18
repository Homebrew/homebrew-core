class Libpaper < Formula
  desc "Library for handling paper characteristics"
  homepage "https://github.com/rrthomas/libpaper"
  url "https://github.com/rrthomas/libpaper/releases/download/v2.1.0/libpaper-2.1.0.tar.gz"
  sha256 "474e9575e1235a0d8e3661f072de0193bab6ea1023363772f698a2cc39d640cf"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "47e3941deebafbec31d1767d0616f1f93c5c4f54f103d4deead70ec8bc3a2974"
    sha256 arm64_monterey: "d5c97821847d75c1049c00254070b3e023faeeecb1d002a406e78bb26ae632a4"
    sha256 arm64_big_sur:  "cf6bbc62e43ed779ae30c1b202384d4cdaa5805496eeb8222edfc155b442b2bd"
    sha256 ventura:        "45ccab2a30ce42c8cde39d4afeba336ca90f35885fe5ef972b7f8f584bac7a14"
    sha256 monterey:       "481c97cd5b1db9fa8890a4116c6d3e4ba40eaccbae3f4da3a83ec023bcf0426e"
    sha256 big_sur:        "6376a9507a200d16f91cd61f758f3bfaecc9aac6f8e8184ea722ce87df0d97d2"
    sha256 x86_64_linux:   "c2d1a4515ef060dbade86e51188b7f97c6582eaed9a23ca1f8dbc738c34cafef"
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
