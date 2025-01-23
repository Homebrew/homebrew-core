class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "https://waterlan.home.xs4all.nl/dos2unix.html"
  url "https://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.5.2.tar.gz"
  mirror "https://fossies.org/linux/misc/dos2unix-7.5.2.tar.gz"
  sha256 "264742446608442eb48f96c20af6da303cb3a92b364e72cb7e24f88239c4bf3a"
  license "BSD-2-Clause"

  livecheck do
    url "https://waterlan.home.xs4all.nl/dos2unix/"
    regex(/href=.*?dos2unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6782d0760a276f44db668e01a49edd85986d20a08fbd35fd1e72346591a37be3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34b49544a0f299d1b2b0c391927b7c07201274a2c8bf682c0991ced19209501d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e739f5c6536d3fc4fa9a8922197379137322925c4476ee28f52e8e02875f61b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49bf57eaaa0a8fca72406d02a7b3b7d50107736cea3c3c01036543387b9668fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "599b519868373bb9ee6258f31375f016b3f44242771bf5553ab52d3a2f9177c9"
    sha256 cellar: :any_skip_relocation, ventura:        "8e7421cfd610a505a2f653dfb064f6fd51a910e4a31b8ec615cc549f579796bf"
    sha256 cellar: :any_skip_relocation, monterey:       "6b0355a4247caca8cbf8cfd8fe7b6aee2db4e749184ab656b407f6c8b7c637eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "228436301f23d4b7b80cf0bfcf1f75d7cff50fd3134baf1c2f2d2b25538fa178"
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
