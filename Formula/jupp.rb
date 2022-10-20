class Jupp < Formula
  desc "Professional screen editor for programmers"
  homepage "https://www.mirbsd.org/jupp.htm"
  url "https://www.mirbsd.org/MirOS/dist/jupp/joe-3.1jupp40.tgz"
  version "3.1jupp40"
  sha256 "4bed439cde7f2be294e96e49ef3e913ea90fbe5e914db888403e3a27e8035b1a"
  license "GPL-1.0-or-later"
  # Upstream HEAD in CVS: http://www.mirbsd.org/cvs.cgi/contrib/code/jupp/

  bottle do
    sha256 arm64_monterey: "7939bd0c91feb1fba1cea7a799903349cf6fc71647310727d4b211d7fdef49f1"
    sha256 arm64_big_sur:  "6616e4a816c8ca98a86e1b38216dedbdd32b522719e82781a532aa10467ca773"
    sha256 monterey:       "ee080bd11833bd22afa9575c27ebe6d256fce4027897e3e3af9ba35f0ecc4d60"
    sha256 big_sur:        "92159e37d64db36ef92ef8a15feff3f079cac1e06c40573dc662a3242cb9ff1c"
    sha256 catalina:       "98e0bea13006ac20f71cd2b5965d5b7b5e55b765edaecaf426d5d6c64511acff"
    sha256 x86_64_linux:   "1b8bff4f0f7c413c61f682f09dd6a282dfb5b7b77add0dc7994bab0c96310a58"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "expect" => :test

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  conflicts_with "joe", because: "both install the same binaries"

  def install
    ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin" if OS.mac?
    system "autoreconf", "-vfi"
    system "./configure", *std_configure_args,
                          "--enable-sysconfjoesubdir=/jupp"
    system "make", "install"
  end

  test do
    assert_match "File (Unnamed) not changed so no update needed.",
      pipe_output("env TERM=tty expect -",
                  "spawn #{bin}/jupp;send \"q\";expect eof")
  end
end
