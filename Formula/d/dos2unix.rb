class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "https://waterlander.net/dos2unix/"
  url "https://waterlander.net/dos2unix/files/dos2unix-7.5.6.tar.gz"
  sha256 "63650acbd0c7fa8623429bcbf93a888e3351a1cad0f556cf41876f5673dd7d0b"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?dos2unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6114abd091cacf37f5b205f486b2f288577b695f16a9c8fc4a6677c8e77f5b4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de3ed10fa56965d80c1bd2a9a746444936d6db0693c7c58b42298a66b79b1b5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e4d437649306968689a212057c7892ab10cdae851dbf6c9a898b570749e3438"
    sha256 cellar: :any_skip_relocation, sonoma:        "5119f07165efb5b8c4e742bd26be1be8eae2bd84ad860f570393cfc3b91392f1"
    sha256 cellar: :any,                 arm64_linux:   "9930687e50a3ae8860242ab384e994da9feb2624b9bcb242d7d8ef307f3247b1"
    sha256 cellar: :any,                 x86_64_linux:  "7ce24121289809b17d480b45ee3b8020511548c2ea7d7a2bbecc32276ff0d9cf"
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
