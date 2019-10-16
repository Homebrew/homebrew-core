class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.12.1.tar.xz"
  sha256 "7e035f142a51fca1359705792627a282456d49749bf62a37a8e48375d41baaa9"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "6e014274755eea746204793b4f6a1bbe1e338af984c23f9eedf51f2d631d17eb" => :catalina
    sha256 "b014bfa6f440a8d06d2da28261e575b68e15cd1c2a34d42ae37777e97ce15827" => :mojave
    sha256 "605df5ce325dcea0c6cb00349cf016b154f122e90fb1f7fcb791de9e6b0e48ae" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

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

    system "./configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write Utils.popen_read("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
