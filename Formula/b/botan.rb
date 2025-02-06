class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-3.7.1.tar.xz"
  sha256 "fc0620463461caaea8e60f06711d7e437a3ad1eebd6de4ac29c14bbd901ccd1b"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "4b99b6b1fbd3e8f79d834dfd7aedc4c965ed5324be305039306f79600c6bba47"
    sha256 arm64_sonoma:  "fce0ad44a2808ebd116abfa266002bbbfe963f82a9ccc2d431399e0e07854cff"
    sha256 arm64_ventura: "17f8b2ddfef80c6d7bfe7fd1f8667ed85a919231e0d6721a76fa6d2c6f4fc5e5"
    sha256 sonoma:        "017161cab3bb069ba19443e80a721083fff6a37b87826d92b9c5fd3de47a2df2"
    sha256 ventura:       "01b2b53465073d0e3309756d767ae6884b3a00653afce73a421333d32276c859"
    sha256 x86_64_linux:  "b1885d55ab656d8e509999458bbe6c5d91055bb4d84237f6de59dc01044ce94e"
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
