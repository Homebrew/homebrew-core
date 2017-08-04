class Pngcrush < Formula
  desc "Optimizer for PNG files"
  homepage "https://pmt.sourceforge.io/pngcrush"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.8.12/pngcrush-1.8.12.tar.xz"
  sha256 "591b0de2f241c60e3eb57435a2280e62a2184aaa8e3bb82a648077b54b34b921"

  bottle do
    cellar :any_skip_relocation
    sha256 "255db9f0ae400173a0486d674e1f9995c54d2bfa6bce70fa7359549342ca5253" => :sierra
    sha256 "9ee84cf4494310f01f291c9a2080de62be068288b5b6fb639db7fbdde8e9f2a1" => :el_capitan
    sha256 "4d9f65bb65b96210865edb046c72b16609e335439e05d2dedf8690bf62575cee" => :yosemite
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
