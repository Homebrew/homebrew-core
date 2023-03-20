class Libpaper < Formula
  desc "Library for handling paper characteristics"
  homepage "https://github.com/rrthomas/libpaper"
  url "https://github.com/rrthomas/libpaper/releases/download/v2.0.10/libpaper-2.0.10.tar.gz"
  sha256 "34938c376ad9ba706dd0f1b30e3de0cb5fe54b47e528ae8a7f1fee062dc42c72"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "8d11b4c40cbcacffe5697e9e5520bbaa08a40780afc7f98ac8f985e5a7a1fa99"
    sha256 arm64_monterey: "4fc73ba142e1c5180a456518d2ce1d18981bb1b767c69f601c0354775372be3b"
    sha256 arm64_big_sur:  "094c923c983eb3de540ce55a14bc9c6458a165d67be4e3b54e5533092a0b629d"
    sha256 ventura:        "f5e40dfe819333656d4608a8bfbd3aedcc01617df97bfa05ee1e0f92e50ecf68"
    sha256 monterey:       "2e56c7de33b57b0269a63f2cbbc902cad907442fef8f01be5f5afc94918b61ef"
    sha256 big_sur:        "a1f4eea29cbfe97cd19e73a6971a8a105087193df35351a70285290db1883345"
    sha256 x86_64_linux:   "dec6e0cb998b111ea0380277ac4728cc22cff4ae9959df6c9bec481577703f9f"
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
