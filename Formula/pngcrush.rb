class Pngcrush < Formula
  desc "Optimizer for PNG files"
  homepage "http://pmt.sourceforge.net/pngcrush/"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.8.7/pngcrush-1.8.7.tar.gz"
  sha256 "a1bc05b2847492afd1fc53d9797d2c99581567ffab59296f613b07586ffc75f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "c693bce9590eae0b7b8abda1c234eebc3a81ecd07cebb253d564bb7afb2fed08" => :sierra
    sha256 "ca2b8ef288519b402029386616a3c0e591b9dd157df84e8c219106465d320642" => :el_capitan
    sha256 "884fd72417efb852d049114ba06f276a750fa03ffef5bbd956784a119f1947c2" => :yosemite
  end

  def install
    # Required to enable "-cc" (color counting) option (disabled by default
    # since 1.5.1)
    ENV.append_to_cflags "-DPNGCRUSH_COUNT_COLORS"

    system "make", "CC=#{ENV.cc}",
                   "LD=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}"
    bin.install "pngcrush"
  end

  test do
    system "#{bin}/pngcrush", test_fixtures("test.png"), "/dev/null"
  end
end
