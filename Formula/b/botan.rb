class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-3.6.1.tar.xz"
  sha256 "7cb8575d88d232c77174769d7f9e24bb44444160585986eebd66e749cb9a9089"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "aa3ffa7f992ddeb2adba8cb0e27985fba64fad225be7afea32fc0f8728eb1ee7"
    sha256 arm64_sonoma:  "4e171bb8229ece404b73b6474eb064f5c60b7676fb5f183673c63065b80ba23d"
    sha256 arm64_ventura: "ee3a85635200f2337b748670090acf0b657e2a0a9dfb0d3c576ce424fe08621c"
    sha256 sonoma:        "75e040ec6ba6aba8e8a2d593fd265d11442beb1afb5fcd8020ea42f1dc4c690b"
    sha256 ventura:       "fcd8fda55320db1390e0e871957bfbbfca04e8d744da4af48f6758f22acf52fa"
    sha256 x86_64_linux:  "e26d10788a66b623e5c9d2b127303963062cb47f6562f0c127a1e97f6e502169"
  end

  depends_on "pkgconf" => :build
  depends_on "ca-certificates"
  depends_on "python@3.13"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1400
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  def python3
    which("python3.13")
  end

  def install
    ENV.runtime_cpu_detection

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --with-zlib
      --with-bzip2
      --with-sqlite3
      --system-cert-bundle=#{Formula["ca-certificates"].pkgetc}/cert.pem
    ]
    args << "--with-commoncrypto" if OS.mac?

    if OS.mac? && DevelopmentTools.clang_build_version <= 1400
      ENV.llvm_clang

      ldflags = %W[-L#{Formula["llvm"].opt_lib}/c++ -L#{Formula["llvm"].opt_lib} -lunwind]
      args << "--ldflags=#{ldflags.join(" ")}"
    end

    system python3, "configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write shell_output("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
