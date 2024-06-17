class Gforth < Formula
  desc "Implementation of the ANS Forth language"
  homepage "https://www.gnu.org/software/gforth/"
  url "https://ftp.gnu.org/gnu/gforth/gforth-0.7.3.tar.gz"
  sha256 "2f62f2233bf022c23d01c920b1556aa13eab168e3236b13352ac5e9f18542bb0"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "d630a48eba921bafb2c5ee8c6c92372c82eddca1c09b957fa6ed0546614f2d4a"
    sha256 arm64_ventura:  "5338b68e5c73e09b9bb05abe64d434d4a68df62a5ee07b45e6852ddb33d14ae9"
    sha256 arm64_monterey: "88e70671a76d3012c1a968056b7a48e006e10cf1e9115322e627c6d90ea3b504"
    sha256 arm64_big_sur:  "abb4ada62e3e52e94056c16e69258b058360592e2408ec19d1f5fc803da6ecf0"
    sha256 sonoma:         "1ca371987c27190729facb4a43f3fa3e2562cc4efd2bf3759a28ddfa0de38c7f"
    sha256 ventura:        "70a64aa5969292059b5a284473fc5676b06f53248c942b69f77f072eb2dc3037"
    sha256 monterey:       "679a6c16f2b39d18f1430f02e0904a4f1102675e9de018f6032f9b2d7c727479"
    sha256 big_sur:        "95ea067782d74310f18e223546a868bcec0a7f4869e335d6c15c30e559e5ef95"
    sha256 catalina:       "f8acb137af0f0005116a15761d2ef72cd721416f6ed1d88ad86f2a0655296e1e"
    sha256 x86_64_linux:   "187183a4751b63734bccc9021f00f44c118623d4bf8c2bddc1c167c9194e6be3"
  end

  depends_on "emacs" => :build
  depends_on "libtool"
  uses_from_macos "libffi"

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version if OS.mac?

    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make", "EMACS=#{Formula["emacs"].opt_bin}/emacs"
    elisp.mkpath
    system "make", "install", "emacssitelispdir=#{elisp}"

    elisp.install "gforth.elc"
  end

  test do
    assert_equal "2 ", shell_output("#{bin}/gforth -e '1 1 + . bye'")
  end
end
