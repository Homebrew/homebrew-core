class Libshout < Formula
  desc "Data and connectivity library for the icecast server"
  homepage "https://icecast.org/"
  url "https://downloads.xiph.org/releases/libshout/libshout-2.4.5.tar.gz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/libshout/libshout-2.4.5.tar.gz"
  sha256 "d9e568668a673994ebe3f1eb5f2bee06e3236a5db92b8d0c487e1c0f886a6890"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/libshout/?C=M&O=D"
    regex(/href=.*?libshout[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "f1490d2569813b44c082e8e040d0fa89dfbc01e7b85b73a52c37a26415cfc794"
    sha256 cellar: :any,                 big_sur:       "2af4498af2e733f0362fc204309d0d1aba893e8ebc66c8c65882c9a73f829d3a"
    sha256 cellar: :any,                 catalina:      "a791567ecf1d73d8f04d643d9698201348c671a118a78f8689b2b558dc10a026"
    sha256 cellar: :any,                 mojave:        "dc69a84a8e5089f8e8af3e567db1cad3eb0b126ca800c83e371097fa78c1dcdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d2f525a9d538ce13d737465420bcf8ee7436a9d1ccb45e173b438e2980af50f"
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "speex"
  depends_on "theora"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end
end
