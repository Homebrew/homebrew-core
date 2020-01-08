class Par < Formula
  desc "Paragraph reflow for email"
  homepage "https://web.archive.org/web/20190921042412/www.nicemice.net/par/"
  url "https://web.archive.org/web/20190921042412/www.nicemice.net/par/Par152.tar.gz"
  version "1.52"
  sha256 "33dcdae905f4b4267b4dc1f3efb032d79705ca8d2122e17efdecfd8162067082"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "9862bdce3a73b66ac07515ddc63190f9ac112a022b04d8caae3a78dbb18cc0d2" => :catalina
    sha256 "5f35670c248a421d3b8d4605ea689d3d40f2a9a902d91a3ad8b5d6802564d4cf" => :mojave
    sha256 "a73f538602df2f35f6d10b8a50fb893a26b407e5e5bc2e2065c9c2b9bcdce668" => :high_sierra
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
