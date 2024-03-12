class Libpaper < Formula
  desc "Library for handling paper characteristics"
  homepage "https://github.com/rrthomas/libpaper"
  url "https://github.com/rrthomas/libpaper/releases/download/v2.2.4/libpaper-2.2.4.tar.gz"
  sha256 "985037a75829dcbab6e9a4b6651731848f4a1720e647f97d2155ee8e40c2ab38"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "6daa5b0424b9c4aba3c5f3f2de108af402381d438732c48fa31b996cab2bdcf8"
    sha256 arm64_ventura:  "ff4600d575e47d33f9640c93834ccbdf5ba7c99b11d1bcb3760c8ccfc8746c89"
    sha256 arm64_monterey: "197776b9bdad9682e42be844589467672d0ca8ec8dd56ae084e784168f01e710"
    sha256 sonoma:         "22ab8ccba69a067d5f8b34b4e209de4a11b5f4fa0c6ac2eecd97227c7ac7e55a"
    sha256 ventura:        "3d71099c1dc44c3153ece6384caee390a18754a17459eabda26131e5b4d8fa9f"
    sha256 monterey:       "21ded4ed1d1227dbab1b495a0cab1ba4dabbe57af60f6cc6b2bf680e675abf3e"
    sha256 x86_64_linux:   "4e1ce257311a09fec836d586158e254a5d9f074768ca9cd8f8e0c4806e10d0f8"
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
