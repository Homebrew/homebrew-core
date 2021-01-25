class Cabocha < Formula
  desc "Yet Another Japanese Dependency Structure Analyzer"
  homepage "https://taku910.github.io/cabocha/"
  # Files are listed in https://drive.google.com/drive/folders/0B4y35FiV1wh7cGRCUUJHVTNJRnM
  url "https://dl.bintray.com/homebrew/mirror/cabocha-0.69.tar.bz2"
  mirror "https://mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/cabocha-20160909/cabocha-0.69.tar.bz2"
  sha256 "9db896d7f9d83fc3ae34908b788ae514ae19531eb89052e25f061232f6165992"

  bottle do
    rebuild 1
    sha256 "1dd5c1474946aaab675326323c8f7e3d101687b50d5542464558f54a8c477cc8" => :big_sur
    sha256 "6db92d4bc14b2b1045601758c9ad2d528fda7ce0029316a2b296c63c4953c54d" => :arm64_big_sur
    sha256 "0cf6edea1fa69790984c762aaff33bcea3d6cf5206e06cf489c53e8644cbc9a4" => :catalina
    sha256 "34825bb06bd8cbdb2fe082471044168cccdafc7414eac37eb6550f8a12e0dbe2" => :mojave
  end

  depends_on "crf++"
  depends_on "mecab"
  depends_on "mecab-ipadic"

  def install
    ENV["LIBS"] = "-liconv"

    inreplace "Makefile.in" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags
      s.change_make_var! "CXXFLAGS", ENV.cflags
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-charset=UTF8
      --with-posset=IPA
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    result = `echo "CaboCha はフリーソフトウェアです。" | cabocha | md5`.chomp
    assert_equal "a5b8293e6ebcb3246c54ecd66d6e18ee", result
  end
end
