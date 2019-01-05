class Libdnet < Formula
  desc "Portable low-level networking library"
  homepage "https://github.com/dugsong/libdnet"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libdnet/libdnet-1.12.tgz"
  sha256 "83b33039787cf99990e977cef7f18a5d5e7aaffc4505548a83d31bd3515eb026"

  bottle do
    cellar :any
    rebuild 2
    sha256 "6655cb89eb5baf7598058283f004556c898c365e3dc1857b052c95b84c2662a6" => :mojave
    sha256 "668c5bef84573868ed3510e414b2d3d8cc092e2776f97e0a0d559e4568ff1db2" => :high_sierra
    sha256 "bfd53f9a4303380ecab6902b181f82a4f229650663443889e1183f4b865d8761" => :sierra
    sha256 "dc34f5bfbe3385420d7fd482029a3acc3c8328ee145a4fe2fc806f6de22e77f4" => :el_capitan
    sha256 "09996ef2a4fce855bd5302996000f5ab49fd28d3e6bf6f0d82d3f11d495baef1" => :yosemite
    sha256 "1b425f04354f60b2c9de0b6e031d50f626d3cda0dc50c892b163107a6eecacb9" => :mavericks
    sha256 "c8fda878e8ff2a87a3b521ca26a5ebb0d4b9eb82868a92149c723c4bf21f5b79" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "python@2" # does not support Python 3

  def install
    # autoreconf to get '.dylib' extension on shared lib
    ENV.append_path "ACLOCAL_PATH", "config"
    system "autoreconf", "-ivf"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-python"
    system "make", "install"
  end

  test do
    system "#{bin}/dnet-config", "--version"
  end
end
