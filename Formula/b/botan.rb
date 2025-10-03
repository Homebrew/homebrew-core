class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-3.9.0.tar.xz"
  sha256 "8c3f284b58ddd42e8e43e9fa86a7129d87ea7c3f776a80d3da63ec20722b0883"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c31c3906ab36e010087ded7fcac7ee943a5e79e1869b57bdac38f8665942e48d"
    sha256 arm64_sequoia: "80a213f3f7a367421f573b1c800d301462c315262f4911e79ac4922020b5160d"
    sha256 arm64_sonoma:  "d2a165badfa80afc40f78c91d43f1369e3c4f3028aa38f9673b9aba073ce6229"
    sha256 arm64_ventura: "5dcd97b9a5a1e247895b073f8abed7347399e255b84485984eaf0a56a2fd60d8"
    sha256 sonoma:        "ba9df5e7e02343af91895fb0c67babf29f66029945fd0947b5d6fed41576b421"
    sha256 ventura:       "5771510c3bcd4d3516f917ca9769d804298c366f3381176aca32637cbfdf7def"
    sha256 arm64_linux:   "b040893534e674ecc74de83979dd98e45a3ef5416bb74d03fab8779e5270d3d6"
    sha256 x86_64_linux:  "c3c83864388e87c59ca19b6f411765b7d264bac735594a06963673456a498d03"
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

      ldflags = %W[-L#{Formula["llvm"].opt_lib}/c++ -L#{Formula["llvm"].opt_lib}/unwind -lunwind]
      args << "--ldflags=#{ldflags.join(" ")}"
    end

    system python3, "configure.py", *args
    system "make", "install"
  end

  test do
    text = "Homebrew"
    base64_enc = pipe_output("#{bin}/botan base64_enc -", text)
    refute_empty base64_enc
    assert_equal text, pipe_output("#{bin}/botan base64_dec -", base64_enc).chomp
  end
end
