class Pngcrush < Formula
  desc "Optimizer for PNG files"
  homepage "https://pmt.sourceforge.io/pngcrush"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.8.12/pngcrush-1.8.12.tar.xz"
  sha256 "591b0de2f241c60e3eb57435a2280e62a2184aaa8e3bb82a648077b54b34b921"

  bottle do
    cellar :any_skip_relocation
    sha256 "69ba01bc2bdd7de877e6463c8d4b6c877e618ba27dc2eb91524b61a15631fd28" => :sierra
    sha256 "cc4ff10c5988d6e39f2a6c7131f772bd919959216a71c612f44792372f1ad127" => :el_capitan
    sha256 "67a4b77fa27efbf2625b2923d955fcf8a16211a311cb6806f034ff07d1522d5c" => :yosemite
  end

  def install
    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    # Reported 20 Aug 2017 https://sourceforge.net/p/pmt/bugs/77/
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace "Makefile", "-DPNGCRUSH_USE_CLOCK_GETTIME=1",
                            "-DPNGCRUSH_USE_CLOCK_GETTIME=0"
    end

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
