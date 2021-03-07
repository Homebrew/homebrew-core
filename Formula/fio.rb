class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.25.tar.gz"
  sha256 "d8157676bc78a50f3ac82ffc6f80ffc3bba93cbd892fc4882533159a0cdbc1e8"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a613a25dfd5b77c237b75b5e0848d79c216e710629e0e7f29c83cf571c60c139"
    sha256 cellar: :any_skip_relocation, big_sur:       "c665a3ba50222002863a421fd34d3a7449b63e7e89dff20e3237a63467f2778c"
    sha256 cellar: :any_skip_relocation, catalina:      "252dd7cba1c767568b9ecb13fbbd891e1ffe47f590ed126cfea8214ff20333f5"
    sha256 cellar: :any_skip_relocation, mojave:        "2b4b3372f9ad040eb974ba38ecdde11c08b0328fae71d785e5d0b88c77ecffc3"
    sha256 cellar: :any_skip_relocation, high_sierra:   "89e47c70a1cca2e1acf29b97720da6b968348ea93a5e417fdca7ad86d670114d"
  end

  uses_from_macos "zlib"

  # Fix build on macOS
  # Remove in the next release
  # See https://github.com/axboe/fio/pull/1154
  patch do
    url "https://github.com/axboe/fio/commit/b6a1e63a1ff607692a3caf3c2db2c3d575ba2320.patch?full_index=1"
    sha256 "bedfdb7d75f07c154d6008c78eb11f51e30d2d8d00ed4f9fe00e705a3c0446e5"
  end

  def install
    system "./configure"
    # fio's CFLAGS passes vital stuff around, and crushing it will break the build
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "sharedir=#{share}",
                   "CC=#{ENV.cc}",
                   "V=true", # get normal verbose output from fio's makefile
                   "install"
  end

  test do
    system "#{bin}/fio", "--parse-only"
  end
end
