class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.25.tar.gz"
  sha256 "d8157676bc78a50f3ac82ffc6f80ffc3bba93cbd892fc4882533159a0cdbc1e8"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "92ab29de16f4c30e39280b99cba069ed03c948b98a2f929acdcab01c35f9cd16"
    sha256 cellar: :any_skip_relocation, big_sur:       "f1bdc63c280e34e214bc569480d317e957f93fe1d36f68c091f641f83d345b75"
    sha256 cellar: :any_skip_relocation, catalina:      "3c43bc09449260fe0ce84250b75c9c92dcd441f823542105260c684bf8331003"
    sha256 cellar: :any_skip_relocation, mojave:        "b1ac6ab2cac3b7833fdd336a5c5a1e811ec071f8b64edab9ac819ea87dc09635"
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
