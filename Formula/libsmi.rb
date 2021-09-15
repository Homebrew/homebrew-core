class Libsmi < Formula
  desc "Library to Access SMI MIB Information"
  homepage "https://www.ibr.cs.tu-bs.de/projects/libsmi/"
  url "https://www.ibr.cs.tu-bs.de/projects/libsmi/download/libsmi-0.5.0.tar.gz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/libsmi/libsmi-0.5.0.tar.gz"
  sha256 "f21accdadb1bb328ea3f8a13fc34d715baac6e2db66065898346322c725754d3"

  livecheck do
    url "https://www.ibr.cs.tu-bs.de/projects/libsmi/download/"
    regex(/href=.*?libsmi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "608287866cf55d742ebe601ff14e984f39a3e7b11374d461b4dc3e5a41854ca6"
    sha256 cellar: :any, big_sur:       "5c3ea572911edc5c6beb54b78e34d840dc458d6b0b5f465298fd0fe673f117be"
    sha256 cellar: :any, catalina:      "1a25b44883bb95940e789ec6395dfa796ec44fd4e0d9ae1ee81a4119fe70ac14"
    sha256 cellar: :any, mojave:        "507d7f52bd7be5c1cc3170831de43e3ebd5a4312b6eda5d795d7519437016246"
    sha256 cellar: :any, high_sierra:   "25a31cf7557ddfc1174a932b904d6c96bda4f3c733caf8258edbdef376e99544"
    sha256               x86_64_linux:  "7c1d475b1062dec302c4022771cbed447f00923a404a1ea131b79796f44d07f5"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smidiff -V")
  end
end
