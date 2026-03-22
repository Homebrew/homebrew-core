class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "https://waterlan.home.xs4all.nl/dos2unix.html"
  url "https://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.5.4.tar.gz"
  mirror "https://fossies.org/linux/misc/dos2unix-7.5.4.tar.gz"
  sha256 "f811a2b9e4a0c936c61ef7c1732993d1820e5cf011f4d93861885ccb8101ca21"
  license "BSD-2-Clause"

  livecheck do
    url "https://waterlan.home.xs4all.nl/dos2unix/"
    regex(/href=.*?dos2unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f48b3846b387e212bd4ca051eb32739aa476305389b3b1cd27a0d38c131ec7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "239d0877e2fd028bcc4df0f66a86bdce32c85e3b473f9d1496e6f00f403fe082"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c58f0d00b0c0b62f631c72ff4c13d4817a60d88a0fe33154315071320ea94c55"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d0e070195b9a64348d2587fd10abd2849542cd044dbb4e330e4f228c30edad6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fa8742ac06a538e56623d3fa36f024516359497d658e9c3463436568780871b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f4e6a8f91f8d4bad774b9fbcbf65a849528b17bdacfa8d8d1ba56f29b6d293d"
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
