class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.5.0.tgz"
  sha256 "b8a31fe03e7f048a5bd3967ecd04b6a48966215e78792df06e333b0eede4fb1b"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "1dc2fa247b7e1bc798b3416d61937741973504a19f6a6660a92adb52d8a18c4e" => :high_sierra
    sha256 "882dbeaaba1a28930123647f7f2c9d12fc9fba8e0e278b1e7ebfcd043e8ef7aa" => :sierra
    sha256 "573407892e3e7612c319e4f47111f478000047d1e7950a2c022f4bf7ddd04c0b" => :el_capitan
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
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write Utils.popen_read("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
