class Cutter < Formula
  desc "Unit Testing Framework for C and C++"
  homepage "https://cutter.osdn.jp/"
  url "https://osdn.mirror.constant.com/cutter/73761/cutter-1.2.8.tar.gz"
  sha256 "bd5fcd6486855e48d51f893a1526e3363f9b2a03bac9fc23c157001447bc2a23"
  license "LGPL-3.0"
  head "https://github.com/clear-code/cutter.git", branch: "master"

  livecheck do
    url "https://osdn.net/projects/cutter/releases/"
    regex(%r{value=["'][^"']*?/rel/cutter/v?(\d+(?:\.\d+)+)["']}i)
  end

  bottle do
    sha256 arm64_monterey: "3e314f0acebc224eabaa266508356e09142f2834d7b6b2b1611d66eacc2496e3"
    sha256 arm64_big_sur:  "ac45c9987b4d770856db1f5e2c8fc20fb1ed882297c22691fe29fb153f7b9828"
    sha256 monterey:       "f6288d98ed9a5fd49d2223ae5a426bed1c9503672f971aae3d1433ebaf2f0d13"
    sha256 big_sur:        "3ac33f6c41d14b9d1fd3486fe811dda6219d45930b0359f4300b69c50a56572d"
    sha256 catalina:       "237aebfb6d39c2efcbbc27e550fbac0a6d1477b549416b69aa71c53c06dce231"
    sha256 mojave:         "70999a7a96da94c5de52da9edb4bf9b3fe5e7b2372d189ccc5a7328f0c21400c"
    sha256 high_sierra:    "ccff0989fe28eeb233bf0cc1f3681041d1945f6e3b0c2700899b8f02581426b6"
    sha256 x86_64_linux:   "1f0d55c82c767d2f7d947bdc054a43d381bc6c1b2b09adc2bd3e7e8381059eb2"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  uses_from_macos "perl" => :build

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-goffice",
                          "--disable-gstreamer",
                          "--disable-libsoup"
    system "make"
    system "make", "install"
  end

  test do
    touch "1.txt"
    touch "2.txt"
    system bin/"cut-diff", "1.txt", "2.txt"
  end
end
