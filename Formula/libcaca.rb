class Libcaca < Formula
  desc "Convert pixel information into colored ASCII art"
  homepage "http://caca.zoy.org/wiki/libcaca"
  url "https://github.com/cacalabs/libcaca/releases/download/v0.99.beta20/libcaca-0.99.beta20.tar.bz2"
  mirror "https://fossies.org/linux/privat/libcaca-0.99.beta20.tar.bz2"
  version "0.99b20"
  sha256 "ff9aa641af180a59acedc7fc9e663543fb397ff758b5122093158fd628125ac1"
  license "WTFPL"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9ab9784b446494822823d030a3469c05f5195bc399bbb7c572d17469ed9b258c"
    sha256 cellar: :any,                 arm64_big_sur:  "49547bb139e2ed778c36c881a73d0ec51d3c0b978873db0587b3936b87c55d0b"
    sha256 cellar: :any,                 monterey:       "e2233e36276fece39a2a1cba166a15f4c07a64ca93ca99e1dd2d9267e87afd0f"
    sha256 cellar: :any,                 big_sur:        "fca71650e2702ac497560f86779bbc77acb5fd8cf09c8219c2381be20af6d11e"
    sha256 cellar: :any,                 catalina:       "3d2d080e206d0d7d9720687aadfce949e78588df510b9039ff1b8f4277015d6d"
    sha256 cellar: :any,                 mojave:         "38488f0e4363948a80d60201da73c6c67856525ff0b67cfd53dc3caa16de602e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "635b337217281620fd72e3ef25992d3c92b8212be752001a3a36f227df13cb51"
  end

  head do
    url "https://github.com/cacalabs/libcaca.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "imlib2"

  def install
    system "./bootstrap" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-cocoa
      --disable-csharp
      --disable-doc
      --disable-java
      --disable-python
      --disable-ruby
      --disable-slang
      --disable-x11
    ]

    system "./configure", *args
    system "make"
    ENV.deparallelize # Or install can fail making the same folder at the same time
    system "make", "install"
  end

  test do
    cp test_fixtures("test.png"), "test.png"
    assert_match "\e[0;5;34;44m", shell_output("#{bin}/img2txt test.png")
  end
end
