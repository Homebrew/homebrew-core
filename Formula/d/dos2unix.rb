class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "https://waterlander.net/dos2unix/"
  url "https://waterlander.net/dos2unix/files/dos2unix-7.5.7.tar.gz"
  sha256 "669ee27120ae71589f638fe3a167d6ea54f8633f5ab1b282551bd7a7c9510dfa"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?dos2unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7daae03638d9fcef0cd8bde6ea3b66af9611036d1349168a2152d6bda0506fdb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9f5c3269baaa4692d28c8764c330d7b57a211793f27d410a07a5dc64ef050fa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8fcff72222089be3e3015f6b02d980bf81725390237c27d824d2a1ca6b9790e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "33227a27d265055063f103eb3503ca93d90546cc52417503b60565caa30396d6"
    sha256 cellar: :any,                 arm64_linux:       "ea643ad8db6b38be94b9c67ec1bfd1ef664067569df61745a040cdaa508472c0"
    sha256 cellar: :any,                 x86_64_linux:      "16bdc27badba287098103e6b6f772e433e8191903d3beb4e662df3ee97695866"
  end

  deny_network_access!

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
