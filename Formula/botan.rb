class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.10.0.tgz"
  sha256 "88481997578c27924724fea76610d43d9f59c99edfe561d41803bbc98871ad31"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "654637d784fd7b2d9c40052f7bf96d3df4cb5b2a0f5c4a86836af6a613d25d7b" => :mojave
    sha256 "d50a864744656076f3ca71646a4c88d74b92c786847b3e9b81c8c50616557e07" => :high_sierra
    sha256 "7f79586f670de597ee1e11e7daa03787eb203fa41b2f3b7c68e3d6fdc59519b3" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

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
