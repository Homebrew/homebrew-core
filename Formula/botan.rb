class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.1.0.tgz"
  sha256 "460f2d7205aed113f898df4947b1f66ccf8d080eec7dac229ef0b754c9ad6294"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "ec915cf50b15d82458cebb8747fb0944e8fac4392ada7744f4955ee96d3a2d7a" => :sierra
    sha256 "6516ec27dc5f5734a429804eed220945da8b81eaa74082be771c1f5ffd0e433f" => :el_capitan
    sha256 "e0c9b7e6b1db9c4d9c74c51d640484dea87c795853aefea13dcc69114aefd9e7" => :yosemite
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
