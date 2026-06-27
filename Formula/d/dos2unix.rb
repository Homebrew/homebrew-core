class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "https://waterlan.home.xs4all.nl/dos2unix.html"
  url "https://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.5.5.tar.gz"
  mirror "https://fossies.org/linux/misc/dos2unix-7.5.5.tar.gz"
  sha256 "75f692b8484c8c24579a2ffd87df16b9c9428ed95497e3393a21d1ba0697ac33"
  license "BSD-2-Clause"

  livecheck do
    url "https://waterlan.home.xs4all.nl/dos2unix/"
    regex(/href=.*?dos2unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a477b3382ab9313f2d7633766dd6c569f8cfc106a075490aa066cc78b523832a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5440cff453f035c62da937754098661bd8cec168b321266db8095419db4c5c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbeca6ca69352db22604724207e1016958ed1fcc4dd7764a588870a3ad9ae2dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3886a2b73c66dbb7022830abed547bbb7cda9bc792a83ffe1063efbb8504401"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c93c6f2b3419d3f36f0bf9db9640e2670a484345e2a505537aac063f6e910ec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18a491699d80991dddeaab7f582db01d26287efe6d23e93b259d1cf0685ddb81"
  end

  def install
    args = %W[
      prefix=#{prefix}
      CC=#{ENV.cc}
      CPP=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      ENABLE_NLS=
      install
    ]

    system "make", *args
  end

  test do
    # write a file with lf
    test_file = testpath/"test.txt"
    test_file.write "foo\nbar\n"

    # unix2mac: convert lf to cr
    system bin/"unix2mac", test_file
    assert_equal "foo\rbar\r", test_file.read

    # mac2unix: convert cr to lf
    system bin/"mac2unix", test_file
    assert_equal "foo\nbar\n", test_file.read

    # unix2dos: convert lf to cr+lf
    system bin/"unix2dos", test_file
    assert_equal "foo\r\nbar\r\n", test_file.read

    # dos2unix: convert cr+lf to lf
    system bin/"dos2unix", test_file
    assert_equal "foo\nbar\n", test_file.read
  end
end
