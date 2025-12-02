class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "https://waterlan.home.xs4all.nl/dos2unix.html"
  url "https://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.5.3.tar.gz"
  mirror "https://fossies.org/linux/misc/dos2unix-7.5.3.tar.gz"
  sha256 "28a4b0d9f9179da4e44c567b9c01f818b070a20827115fffd96f760dcfa0f3b2"
  license "BSD-2-Clause"

  livecheck do
    url "https://waterlan.home.xs4all.nl/dos2unix/"
    regex(/href=.*?dos2unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a4f1d549630f2b7d913b78f5928eb1a76af2534ac182e46636f1e5ee2d8b62c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da0bed04130bc8e767908d32e744f8d5ce7a88941af553d8534dafbb6f502847"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88d9e7167d007f9e25dfa962db52556e13f7dfcd58e2cddb2782f1181e69aa2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "062aea79a6599994b28d5518231ae6a1f447a58795f73e029ee73d1ff1e237cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9264c8e7094220261ad7a6c5a8f394e00685bca15abe249fffc7782750d47eb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7802a620432af0710bef945aaa0d15190b66274f889bea9c31bf2862ad71b6e"
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
