class Libcaca < Formula
  desc "Convert pixel information into colored ASCII art"
  homepage "http://caca.zoy.org/wiki/libcaca"
  url "http://caca.zoy.org/raw-attachment/wiki/libcaca/libcaca-0.99.beta19.tar.gz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/libcaca/libcaca-0.99.beta19.tar.gz"
  mirror "https://fossies.org/linux/privat/libcaca-0.99.beta19.tar.gz"
  version "0.99b19"
  sha256 "128b467c4ed03264c187405172a4e83049342cc8cc2f655f53a2d0ee9d3772f4"
  license "WTFPL"
  revision 3

  # The regex here is looser than usual because it has to match unstable
  # versions for now. If this software is updated in the future to a stable
  # version, this regex should be modified to not match unstable versions.
  livecheck do
    url :homepage
    regex(/href=.*?libcaca[._-]v?(\d+(?:\.\d+)+.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "49547bb139e2ed778c36c881a73d0ec51d3c0b978873db0587b3936b87c55d0b"
    sha256 cellar: :any,                 big_sur:       "fca71650e2702ac497560f86779bbc77acb5fd8cf09c8219c2381be20af6d11e"
    sha256 cellar: :any,                 catalina:      "3d2d080e206d0d7d9720687aadfce949e78588df510b9039ff1b8f4277015d6d"
    sha256 cellar: :any,                 mojave:        "38488f0e4363948a80d60201da73c6c67856525ff0b67cfd53dc3caa16de602e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "635b337217281620fd72e3ef25992d3c92b8212be752001a3a36f227df13cb51"
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

    # Fix --destdir issue.
    #   ../.auto/py-compile: Missing argument to --destdir.
    inreplace "python/Makefile.in",
              '$(am__py_compile) --destdir "$(DESTDIR)"',
              "$(am__py_compile) --destdir \"$(cacadir)\""

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-doc
      --disable-slang
      --disable-java
      --disable-csharp
      --disable-ruby
      --disable-x11
    ]

    system "./configure", *args
    system "make"
    ENV.deparallelize # Or install can fail making the same folder at the same time
    system "make", "install"
  end

  test do
    system "#{bin}/img2txt", "--version"
  end
end
