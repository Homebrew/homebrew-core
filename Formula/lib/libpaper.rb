class Libpaper < Formula
  desc "Library for handling paper characteristics"
  homepage "https://github.com/rrthomas/libpaper"
  url "https://github.com/rrthomas/libpaper/releases/download/v2.2.5/libpaper-2.2.5.tar.gz"
  sha256 "7be50974ce0df0c74e7587f10b04272cd53fd675cb6a1273ae1cc5c9cc9cab09"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia:  "5cc91b5fda115a717061722c837abaadbc85f5071360550babad310894aaa1ae"
    sha256 arm64_sonoma:   "a820b290777d896291f6d651d23de9cc2aeca5261b0b1cce8315f2d3262a80d8"
    sha256 arm64_ventura:  "593d5302b06e046b9857185eefb15e9520dfd1f6cb78cb7dd14326fce7870f87"
    sha256 arm64_monterey: "41d361fb86edc5e1c89ca90c564658c51829d1803b6257b846aba6cbabc48fb1"
    sha256 sonoma:         "968352f2fa3ad4efa75d041c32cce72eecc52de6b7b73c0602c00e27382d06a1"
    sha256 ventura:        "d3d69196897d382e6fe4b95817946893a5c2670eb8e7db1374f2060c3e93bf64"
    sha256 monterey:       "4b0a0366ac5c9d08a2ee532df10c06f9cdfce4ac83f46330e4a99cf7356ed020"
    sha256 x86_64_linux:   "c55d1aa9fc31b51cca277578b6d577a580818c60fd7c189861af98203de348c2"
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
