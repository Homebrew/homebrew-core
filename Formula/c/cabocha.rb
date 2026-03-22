class Cabocha < Formula
  desc "Yet Another Japanese Dependency Structure Analyzer"
  homepage "https://taku910.github.io/cabocha/"
  # Files are listed in https://drive.google.com/drive/folders/0B4y35FiV1wh7cGRCUUJHVTNJRnM
  url "https://distfiles.macports.org/cabocha/cabocha-0.69.tar.bz2"
  mirror "https://mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/cabocha-20160909/cabocha-0.69.tar.bz2"
  sha256 "9db896d7f9d83fc3ae34908b788ae514ae19531eb89052e25f061232f6165992"
  license any_of: ["BSD-3-Clause", "LGPL-2.1-or-later"]

  livecheck do
    url :homepage
    regex(%r{>\d{4}/\d{2}/\d{2}\s+(\d+(?:\.\d+)+)<}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:    "e3862dcd2820bd7abc7984b1ac9449398cad2ec280ca1f757b3809ef7ad8f227"
    sha256 arm64_sequoia:  "10a190b7fea68a71d42b2b95bbae271c6e9c86792c46023b85d8197d9fc1b1f5"
    sha256 arm64_sonoma:   "245d5a46edaedab3ee594cc9aa77d702087daae32db1ff28a70c6207bc0b01b2"
    sha256 arm64_ventura:  "50e7ebda3eb0424fd7e9f7654ecf854c8f3dff2673e257225013f3d3085e7967"
    sha256 arm64_monterey: "c61f5a8df81d52575b991108e2683c27d94a4dcd62cd50d4396cb65234453b22"
    sha256 arm64_big_sur:  "6db92d4bc14b2b1045601758c9ad2d528fda7ce0029316a2b296c63c4953c54d"
    sha256 sonoma:         "c878b08aec360a527c8a78d449889abfc8b122e59589a9b21cba4826f213daa7"
    sha256 ventura:        "f4f6ff225aba6446a3d140dc258f66c55dd8b7077297fae888054c6e10d21c0d"
    sha256 monterey:       "7002f27098ec51a1832a5a39e1f8d55eb7d11b7fe37ce005ff0dfe7bb1be9e59"
    sha256 big_sur:        "1dd5c1474946aaab675326323c8f7e3d101687b50d5542464558f54a8c477cc8"
    sha256 catalina:       "0cf6edea1fa69790984c762aaff33bcea3d6cf5206e06cf489c53e8644cbc9a4"
    sha256 arm64_linux:    "96598b2e47622193fb852eda64753fecff40b088afff67c37538a57f5600e912"
    sha256 x86_64_linux:   "182dfe90c7dcc7c8bf00ece489a1d03b39b1dc66719a58c52efce8f8a8b30b96"
  end

  depends_on "crf++"
  depends_on "mecab"
  depends_on "mecab-ipadic"

  def install
    ENV["LIBS"] = "-liconv" if OS.mac?

    inreplace "Makefile.in" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags || ""
      s.change_make_var! "CXXFLAGS", ENV.cflags || ""
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-charset=UTF8
      --with-posset=IPA
    ]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args
    system "make", "install"
  end

  test do
    md5 = if OS.mac?
      "md5"
    else
      "md5sum"
    end
    result = pipe_output(md5, pipe_output(bin/"cabocha", "CaboCha はフリーソフトウェアです。", 0))
    assert_equal "a5b8293e6ebcb3246c54ecd66d6e18ee", result.chomp.split.first
  end
end
