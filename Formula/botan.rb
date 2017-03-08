class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.0.1.tgz"
  sha256 "a138ed316d11450a8405451b9c9664b8e640a9b7ad84d3f3ad34e8071f364e0b"
  head "https://github.com/randombit/botan.git"

  bottle do
    cellar :any
    sha256 "b04c99b1028e05ee50e28faa590caa40b0cd3d1603fec0da3e61fb64419b39d6" => :sierra
    sha256 "21599053348caae11ed972522334247733ea85776ca5c8d309bcf1aea39d28fa" => :el_capitan
    sha256 "70592ff415e7e30c7a50c2aa46a8b4a0357150c5f98fb1fa11bba5ea48ee978b" => :yosemite
    sha256 "da4e989fedc710e3e65cb6ec387b9fd865740cc1878f660f371522ba255b307f" => :mavericks
  end

  option "with-debug", "Enable debug build of Botan"

  deprecated_option "enable-debug" => "with-debug"

  depends_on "pkg-config" => :build
  depends_on "openssl"

  needs :cxx11

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --cpu=#{MacOS.preferred_arch}
      --cc=#{ENV.compiler}
      --os=darwin
      --with-openssl
      --with-zlib
      --with-bzip2
    ]

    args << "--enable-debug" if build.with? "debug"

    system "./configure.py", *args
    # A hack to force them use our CFLAGS. MACH_OPT is empty in the Makefile
    # but used for each call to cc/ld.
    system "make", "install", "MACH_OPT=#{ENV.cflags}"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write Utils.popen_read("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
