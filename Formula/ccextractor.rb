class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "https://www.ccextractor.org/"
  url "https://github.com/CCExtractor/ccextractor/archive/v0.88.tar.gz"
  sha256 "e0bfad4c7cf5d8a05305107ab53829a33b209446aaec515d5c51b72392b1eda7"
  license "GPL-2.0-or-later"
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "d728849547605c278baea4db869d73a585f79504923b0456819155f1b15a739d"
    sha256 cellar: :any_skip_relocation, catalina:    "aaba08da14a3266a7b60bcd232c24d121ba9aa1741e768f54e77fd09f6c67fcc"
    sha256 cellar: :any_skip_relocation, mojave:      "87a9b43c6ac20b2dc270cc35b1da0df4a92758bc722882407dcacbacb7e806d7"
    sha256 cellar: :any_skip_relocation, high_sierra: "35be2be5fd71b1784b85a7bd5ba7ccf35f987fd6ed0548df7864cd686e28c5c0"
    sha256 cellar: :any_skip_relocation, sierra:      "9c78ad6dd2f3c02ef7ca508af88114f8deffa691cf3a546e6ca09ed279b80758"
  end

  depends_on "freetype"
  depends_on "libpng"
  depends_on "utf8proc"
  depends_on "zlib"

  def install
    cd "mac" do
      cfiles = Dir[
        "../src/ccextractor.c",
        "../src/lib_ccx/*.c",
        "../src/gpacmp4/*.c",
        "../src/lib_hash/*.c",
        "../src/protobuf-c/*.c",
        "../src/zvbi/*.c",
        "../src/wrappers/*.c",
      ]

      flags = %W[
        -std=gnu99
        -Wno-write-strings
        -DGPAC_CONFIG_DARWIN
        -D_FILE_OFFSET_BITS=64
        -DVERSION_FILE_PRESENT
        -Dfopen64=fopen
        -Dopen64=open
        -Dlseek64=lseek
        -DFT2_BUILD_LIBRARY
        -DGPAC_DISABLE_VTT
        -DGPAC_DISABLE_OD_DUMP
        -I../src/
        -I../src/lib_ccx
        -I../src/gpacmp4
        -I../src/lib_hash
        -I../src/protobuf-c
        -I../src/zvbi
        -I#{HOMEBREW_PREFIX}/include
        -I#{Formula["freetype"].opt_include}/freetype2
        -lm
        -liconv
        -lpng
        -lz
        -lutf8proc
        -lfreetype
        -L#{HOMEBREW_PREFIX}/lib
      ]

      system "./pre-build.sh"
      system ENV.cc, "-o", "ccextractor", *cfiles, *flags
      bin.install "ccextractor"
    end
    (pkgshare/"examples").install "docs/ccextractor.cnf.sample"
  end

  test do
    touch testpath/"test"
    pid = fork do
      exec bin/"ccextractor", testpath/"test"
    end
    Process.wait(pid)
    assert_predicate testpath/"test.srt", :exist?
  end
end
