class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://github.com/pornel/pngquant.git",
      :tag => "2.10.1",
      :revision => "b526af94ca3c116239739b8e2ec194bad54926f8"
  head "https://github.com/pornel/pngquant.git"

  bottle do
    cellar :any
    sha256 "145306ad0f1ec6c75714f545c42a4cb6e8863b11a90360e91617af2a567e2e83" => :sierra
    sha256 "53358eac4adf568420d23677d3cdeb7b8e0ac64a296007415938b36d7c27b4d1" => :el_capitan
    sha256 "7552ff56f33a826925b3f7952fdca3b6f2f801b7154b53975781f8a7886dc363" => :yosemite
  end

  option "with-openmp", "Enable OpenMP"

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "little-cms2" => :optional

  needs :openmp if build.with? "openmp"

  def install
    ENV.append_to_cflags "-DNDEBUG" # Turn off debug

    args = ["--prefix=#{prefix}"]
    args << "--with-lcms2" if build.with? "little-cms2"

    if build.with? "openmp"
      args << "--with-openmp"
      args << "--without-cocoa"
    end

    system "./configure", *args
    system "make", "install", "CC=#{ENV.cc}"

    man1.install "pngquant.1"
    lib.install "lib/libimagequant.a"
    include.install "lib/libimagequant.h"
  end

  test do
    system "#{bin}/pngquant", test_fixtures("test.png"), "-o", "out.png"
    File.exist? testpath/"out.png"
  end
end
