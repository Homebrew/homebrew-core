class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  url "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.47/pcre2-10.47.tar.bz2"
  sha256 "47fe8c99461250d42f89e6e8fdaeba9da057855d06eb7fc08d9ca03fd08d7bc7"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^pcre2[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "10bd8c1cf3784ab8a736f01b7f85d091276d69c5a8d48bd022b01209fb4eb870"
    sha256 cellar: :any,                 arm64_sequoia: "603fb4c2e2d04c59cb75525a47758abbab20027f3f2296cc170fba64f9fb4b9a"
    sha256 cellar: :any,                 arm64_sonoma:  "fb34b096f84b0de1dd502b2b35cd5de9a4d1dea85ff8cb032765f8bda1278ca2"
    sha256 cellar: :any,                 tahoe:         "a9a5f8749a644762cc6ca09e4986cdaeecedc050d43b0de19562587cb98ea655"
    sha256 cellar: :any,                 sonoma:        "20d5064b4a9454114faac74629efdd7fbac4cff541488f6cf035ceaeae45c51d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f975aedeebe47c169447cbd9d4bb27ebd883c79a9fbc96154f373f0e07361409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a80460c1a317becfa0cff0659100dfe6aacf0f7679043580c1bb6377b8fce77"
  end

  head do
    url "https://github.com/PCRE2Project/pcre2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-pcre2-16
      --enable-pcre2-32
      --enable-pcre2grep-libz
      --enable-pcre2grep-libbz2
      --enable-jit
    ]

    args << "--enable-pcre2test-libedit" if OS.mac?

    system "./autogen.sh" if build.head?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"pcre2grep", "regular expression", prefix/"README"
  end
end
