class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "https://waterlan.home.xs4all.nl/dos2unix.html"
  url "https://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.5.1.tar.gz"
  mirror "https://fossies.org/linux/misc/dos2unix-7.5.1.tar.gz"
  sha256 "da07788bb2e029b0d63f6471d166f68528acd8da2cf14823a188e8a9d5c1fc15"
  license "BSD-2-Clause"

  livecheck do
    url "https://waterlan.home.xs4all.nl/dos2unix/"
    regex(/href=.*?dos2unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b2ea129fb75887bc152ad6801b0cbfa0cf65439075af4959b03244cebe7c3a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "406e8d43a00635ebe673a875a9220616d4888c057731c423a0e5d0dd7ebf6a78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f64a6b8c31eff382d9653939c06fcf98cdc3ce8b86cfeaa881b9513754c9342"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28054af1e3dcb5d9ff47ff348700f34004eebd21f1ed8b0257089bf15dc04a18"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f64745a518064fda421dbb87af16b2c6af6c09ebb446d23c17448ba5eed1e48"
    sha256 cellar: :any_skip_relocation, ventura:        "9b50d2ac2d3ea8416554ce29ab5e59d95d85b392f60ece56aeee56599e32c5cd"
    sha256 cellar: :any_skip_relocation, monterey:       "4a0b95a44c42d867a424e9656ea9b417a61e6b6ab3db963318316cbcb3e88ff5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8d0cf82af0f55d324fe4521083d31ba15913e031d3837f656038dfb18ae47d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "545462d042d0dab3d7e1d512e5509637c3caa7658ff4fe0d8876df129321b4e1"
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
    path = testpath/"test.txt"
    path.write "foo\nbar\n"

    # unix2mac: convert lf to cr
    system "#{bin}/unix2mac", path
    assert_equal "foo\rbar\r", path.read

    # mac2unix: convert cr to lf
    system "#{bin}/mac2unix", path
    assert_equal "foo\nbar\n", path.read

    # unix2dos: convert lf to cr+lf
    system "#{bin}/unix2dos", path
    assert_equal "foo\r\nbar\r\n", path.read

    # dos2unix: convert cr+lf to lf
    system "#{bin}/dos2unix", path
    assert_equal "foo\nbar\n", path.read
  end
end
