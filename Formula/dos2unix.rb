class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "https://waterlan.home.xs4all.nl/dos2unix.html"
  url "https://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.4.2.tar.gz"
  mirror "https://fossies.org/linux/misc/dos2unix-7.4.2.tar.gz"
  sha256 "6035c58df6ea2832e868b599dfa0d60ad41ca3ecc8aa27822c4b7a9789d3ae01"
  license "BSD-2-Clause"

  livecheck do
    url "https://waterlan.home.xs4all.nl/dos2unix/"
    regex(/href=.*?dos2unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8216cc883ecd01f9c4faaeb4e93d9258a0c20cdbc1c718a58119c8ddaa6e337"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54cb2c42f9f016e03ccf712d0927963fc629d8419de3bfdf324dc51088f87157"
    sha256 cellar: :any_skip_relocation, monterey:       "539e9ff3c1ebce403da947ed6acdabbe45a09e005f2ece880cd3044c32cbefb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a4b0e40724b8721ff76a36cb74fd6c9816ce0e9b518c3abf0e2ec5bab5b0cce"
    sha256 cellar: :any_skip_relocation, catalina:       "eb14b6db2fbf8fa0f52b69aa33101e1eb04bf3d4ef5dae7234754046e4cd54a6"
    sha256 cellar: :any_skip_relocation, mojave:         "7a23d283d81cad13690d788c61117cbfe091282503077ad56bde83f026dd5097"
    sha256 cellar: :any_skip_relocation, high_sierra:    "98858938fe95e2453056d80c03c35396913a5c6902b2df00b618c884a4b51521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "331d745aab1034b696b0f873ccdb1431266ed813215669a5446e7c2285984a2b"
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
