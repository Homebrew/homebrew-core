class Pngcrush < Formula
  desc "Optimizer for PNG files"
  homepage "http://pmt.sourceforge.net/pngcrush/"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.8.11/pngcrush-1.8.11.tar.xz"
  sha256 "8d530328650ec82f3cbe998729ada8347eb3dbbdf706d9021c5786144d18f5b0"

  bottle do
    cellar :any_skip_relocation
    sha256 "255db9f0ae400173a0486d674e1f9995c54d2bfa6bce70fa7359549342ca5253" => :sierra
    sha256 "9ee84cf4494310f01f291c9a2080de62be068288b5b6fb639db7fbdde8e9f2a1" => :el_capitan
    sha256 "4d9f65bb65b96210865edb046c72b16609e335439e05d2dedf8690bf62575cee" => :yosemite
  end

  def install
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
