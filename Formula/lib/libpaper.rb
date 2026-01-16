class Libpaper < Formula
  desc "Library for handling paper characteristics"
  homepage "https://github.com/rrthomas/libpaper"
  url "https://github.com/rrthomas/libpaper/releases/download/v2.2.7/libpaper-2.2.7.tar.gz"
  sha256 "3925401edf1eda596277bc2485e050b704fd7f364f257c874b0c40ac5aa627c0"
  license "LGPL-2.1-or-later"

  bottle do
    sha256               arm64_tahoe:   "9237f117ff7639ec37411bc1186b1c857d83460a4c4309ec4cbdce0286c829ff"
    sha256               arm64_sequoia: "fbbf0d4966874406973fcacb2cd8265b7cc593ad4fb5f65b773f87cfe52dfd9d"
    sha256               arm64_sonoma:  "55b133377debbd9934e790907be38c291863e9c645d4e50401d8231d471e1580"
    sha256 cellar: :any, sonoma:        "32b59bfd2d5a0b5e036a90dc63ab5a2b8826d6f3ca863b2c92e999a7df4e53d9"
    sha256               arm64_linux:   "ae03dd149881ec2ccb3790da8949ad2945b0cc96c02615c6764998ba1ed17342"
    sha256               x86_64_linux:  "2e5c313c3f87f029c4dc2bd6e6c084ddfbed6ff40e322572b5e806e79a1efaa1"
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
