class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.13.0.tar.xz"
  sha256 "f57ae42a41e1091bca58f44f41addebd9a390b651603952c881ec89d50187e90"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "287dfed529e8e3318f53f8b7c15bb28d824ce7d37cc9d0efc31359758b816b34" => :catalina
    sha256 "39b24feecd714f011916d659770f5fbc11cb652b530d6828c066112a4a58283b" => :mojave
    sha256 "a21833781daf9b3c2f227dd71975b787e6e4047756d24adbe897360a40dc3c87" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "python@2" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
