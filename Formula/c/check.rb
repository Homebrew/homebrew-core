class Check < Formula
  desc "C unit testing framework"
  homepage "https://libcheck.github.io/check/"
  url "https://github.com/libcheck/check/releases/download/0.15.2/check-0.15.2.tar.gz"
  sha256 "a8de4e0bacfb4d76dd1c618ded263523b53b85d92a146d8835eb1a52932fa20a"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "ce6a229334822ebeb404ea91776ddb2727e76754724dbc6b7dae91cc274748cd"
    sha256 cellar: :any,                 arm64_sequoia:  "11f6f6c67483ebc4a230480a1b068882a8476afc52517d2d68de0ecc24ea305b"
    sha256 cellar: :any,                 arm64_sonoma:   "62db788052873713c484655c217bb221f71c794df5df63b7a68083df8805f598"
    sha256 cellar: :any,                 arm64_ventura:  "15a4e3c82d688948f0adc02dc5998f1abd24855aa16a4d0b673f46bc46bdcb0a"
    sha256 cellar: :any,                 arm64_monterey: "81a1070f08dca8980cc77fc26b7938410cd1d1317e54cec0612763fe6920f5ab"
    sha256 cellar: :any,                 arm64_big_sur:  "ca05134bbcea8deffd6eabf0c11bed130f3b3bd4d9c917da88cc591220c469c8"
    sha256 cellar: :any,                 sonoma:         "2a257d478a28129338329e653fd58134afb39e0d863096e0d5a15ee155b0eeef"
    sha256 cellar: :any,                 ventura:        "ce18575f3c364179df6701ae91c328d1c2c50a68d700596f867e5bbc1e1b1eca"
    sha256 cellar: :any,                 monterey:       "2b5cbf39a06e76028c9c1bbffa68021bce7b25f58df0c8715155190b35e78867"
    sha256 cellar: :any,                 big_sur:        "98151987096a97d4b1ffeada7645c42ea6784d01149455d4a26800b27ad3b8d7"
    sha256 cellar: :any,                 catalina:       "83176da74de92f8ae589d98726f97466f7ccfa91e2b0b58603c4f909d8ce50a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b2fcfa1c29e058586a152276fb76da860bcae0f064cbe67fe9c9fca46928affb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8c8c28c6d8e01000caec0a7705ee896a15be80f27ce3297fe7e2733fb58f6c5"
  end

  on_linux do
    depends_on "gawk"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.tc").write <<~EOS
      #test test1
      ck_assert_msg(1, "This should always pass");
    EOS

    system "#{bin/"checkmk"} test.tc > test.c"

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcheck", "-o", "test"
    system "./test"
  end
end
