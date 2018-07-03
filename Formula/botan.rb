class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.7.0.tgz"
  sha256 "e42df91556317588c6ca0e41bf796f9bd5ec5c70e0668e6c97c608c697c24a90"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "5c173d12f563c782ea7f66b334b83202e5e07401ca11eb4b3f991f06b168a262" => :high_sierra
    sha256 "81697f0f4796105afbe523422505180d8192576495e841e39f1fd645c0a39002" => :sierra
    sha256 "0de1a4dbee4c5b0b0a50279ac288f3b0d9263739f7ea440d0db5402c843139d4" => :el_capitan
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
