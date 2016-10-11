class Par < Formula
  desc "Paragraph reflow for email"
  homepage "http://www.nicemice.net/par/"
  url "http://www.nicemice.net/par/Par152.tar.gz"
  version "1.52"
  sha256 "33dcdae905f4b4267b4dc1f3efb032d79705ca8d2122e17efdecfd8162067082"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "efa3ba3bdd3b34ad8e5089b8cd5562d8b8cf4a5e5488e54e43dfb45760a1b4fa" => :sierra
    sha256 "3683d5918dc91fcd073fc8e35af2fca416b3756aff8479ff549598bcd2500e8b" => :el_capitan
    sha256 "cb1042ef12ead6645653775571ebe84798b707194922030563ff4056687954e3" => :yosemite
  end

  conflicts_with "rancid", :because => "both install `par` binaries"

  # Patch to add support for multibyte charsets (like UTF-8), plus Debian
  # packaging.
  patch do
    url "http://sysmic.org/dl/par/par-1.52-i18n.4.patch"
    sha256 "2ab2d6039529aa3e7aff4920c1630003b8c97c722c8adc6d7762aa34e795861e"
  end

  def install
    system "make", "-f", "protoMakefile"
    bin.install "par"
    man1.install gzip("par.1")
  end

  test do
    expected = "homebrew\nhomebrew\n"
    assert_equal expected, pipe_output("#{bin}/par 10gqr", "homebrew homebrew")
  end
end
