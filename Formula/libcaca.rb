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
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.gsub(/\.?beta/, "b") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "27d36a5457f9d98cf925cb402e9abb784c0d3453c8036fe74ebdeae04b7a9063"
    sha256 cellar: :any,                 arm64_monterey: "b29bc6f1dd407411eab8689bfe190574b9fdc487d00dbdc7636e9483de867e56"
    sha256 cellar: :any,                 arm64_big_sur:  "afa31ed628299e9d3fb4109b8f05b5b00fc2820c22804f85993eebda9a3097c0"
    sha256 cellar: :any,                 ventura:        "a0fcaf753907e6dabf7d1a2038cdc95444fddf00f7dafd2b6ca88b7f552336ad"
    sha256 cellar: :any,                 monterey:       "c7f6b2b19aaaa1417feac203e5c3676b6c0e70fb72816e16e1b85343e8cf55fb"
    sha256 cellar: :any,                 big_sur:        "efe390bae78561024c804ac37bb5c0cf9f3397229bd91732cb59f9f4e32ecc8c"
    sha256 cellar: :any,                 catalina:       "f0f86157174d749eedaec913f4d8d1b6d00824b6e580498847ac9e00c9c53d9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dab49e0d6bf0ed46dcc831c783da0124e5329f7e0e69f7d8cf847f9b825ebe2"
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
