class Libidn < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/"
  url "https://ftpmirror.gnu.org/gnu/libidn/libidn-1.44.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libidn/libidn-1.44.tar.gz"
  sha256 "499608bab3a65650a0ea52888c13a8deebe3f71408e319acd9ec52e02eb13959"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "56332a793245f898e13eefa84d08e42819d83c249c982687f045c7da71522549"
    sha256 cellar: :any, arm64_sequoia: "cca2f1b581655791c18cfb0384074b78c49ff32b3c13d9ccab12f5fbc949cb4d"
    sha256 cellar: :any, arm64_sonoma:  "6f870f5f9fcff1e40cc5ca5564e19a22880e86b2bcbe0123893ba8ad7ea71063"
    sha256 cellar: :any, sonoma:        "9644d70446c88b456ab55d758d881300e606ea5f9952de4dbe59389e7df86619"
    sha256               arm64_linux:   "7326930bb6b55d6ca28aa93842860e9c0dd1dc04657d9adb32060a210b7feb04"
    sha256               x86_64_linux:  "87c70a4f75f4c37a4c9c7bd2bc2fdaaa3ce21d84a9aa4236adfe55de94e6e772"
  end

  depends_on "pkgconf" => :build

  def install
    system "./configure", "--disable-csharp",
                          "--with-lispdir=#{elisp}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system bin/"idn", "räksmörgås.se", "blåbærgrød.no"
  end
end
