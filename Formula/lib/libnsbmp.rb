class Libnsbmp < Formula
  desc "Decoding library for BMP and ICO image file formats"
  homepage "https://www.netsurf-browser.org/projects/libnsbmp/"
  url "https://download.netsurf-browser.org/libs/releases/libnsbmp-0.1.7-src.tar.gz"
  sha256 "5407a7682a122baaaa5a15b505290e2d37df54c13c5edef4b09d12c862d82293"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?libnsbmp[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "d75c82e5602bfb3c49ca8de06f9bb16002f10f1eb09b6c025d3a4e160f4b8aef"
    sha256 cellar: :any,                 arm64_sequoia:  "334b42b3b30917e7cb0850b079cced2c020a9ffe8389d1a703ffcd2896f64a22"
    sha256 cellar: :any,                 arm64_sonoma:   "9a29a254a2f286b15219fa8e1b95858569fe653728184fa20b83130eb67d5f23"
    sha256 cellar: :any,                 arm64_ventura:  "52b3d890d4ed6f2a9763b7848ca24955059fdeb61b1f097dc230e343f44547c6"
    sha256 cellar: :any,                 arm64_monterey: "c2c58f67547e5a4cfc4c717bbd303cc30542e767632be818af61de3a5b43c25f"
    sha256 cellar: :any,                 sonoma:         "11b45814407dd3a3d4ba8976717cf1a64b425fe776e13d93caa96bb489ff8a6e"
    sha256 cellar: :any,                 ventura:        "e6ae9d7f2d428e878b319086665048a1a58d4b1f6eb96a9c88106f13cbe81968"
    sha256 cellar: :any,                 monterey:       "e67ef1fb84121dcea357001d14e1b2fc6614f0dcb36bda9ce06cb291acf24bf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b5f8e356d95975d6cd0756b0a426cd43abfa1803755b224b6361bf7df5094230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86f827dd9ea13403f33582394b79f80f88117747da6bbbae89d70cde8cef8615"
  end

  depends_on "netsurf-buildsystem" => :build

  def install
    args = %W[
      NSSHARED=#{Formula["netsurf-buildsystem"].opt_pkgshare}
      PREFIX=#{prefix}
    ]

    system "make", "install", "COMPONENT_TYPE=lib-shared", *args
    system "make", "install", "COMPONENT_TYPE=lib-static", *args

    # Also include an example, for use in test block
    inreplace "test/decode_bmp.c", "\"../include/libnsbmp.h\"", "<libnsbmp.h>"
    pkgshare.install "test/decode_ico.c"
  end

  test do
    system ENV.cc, pkgshare/"decode_ico.c", "-I#{include}", "-L#{lib}", "-lnsbmp", "-o", "decode_ico"

    expected_output = <<~EOS
      P7
      # #{test_fixtures("test.ico")}
      WIDTH 8
      HEIGHT 8
      DEPTH 4
      MAXVAL 255
      TUPLTYPE RGB_ALPHA
      ENDHDR
    EOS

    # Image is 8 x 8 = 64 px of pure blue, expressed as RGBA
    expected_output = expected_output.bytes + ([0, 0, 255, 255] * 64)
    assert_equal expected_output, shell_output("#{testpath}/decode_ico #{test_fixtures("test.ico")}").bytes
  end
end
