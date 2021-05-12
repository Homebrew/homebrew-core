class Mjpegtools < Formula
  desc "Record and playback videos and perform simple edits"
  homepage "https://mjpeg.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mjpeg/mjpegtools/2.2.0/mjpegtools-2.2.0.tar.bz2"
  sha256 "a84349839471052db1ef691134aacf905b314dfce8762d47e10edcc9ab5f97d8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4e6e97aa6b84f1269e344708cc2fa5b4fd4cadf7c27da94a1a450a5d7fef45fa"
    sha256 cellar: :any, big_sur:       "cb977ade8f3c1a4949029932bd55be08ffa562b3404dd5594d63885296504f32"
    sha256 cellar: :any, catalina:      "535d927e3f9bbb2bee320d5d254242491b500d01cd7619f10a81a77df4fa4f6a"
    sha256 cellar: :any, mojave:        "d7a3825d1a3fa3b3863ecdf95d88ff17758f61f8d1ef0ea27b38f3a6fa7d165e"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-simd-accel",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
