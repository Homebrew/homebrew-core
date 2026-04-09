class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-3.11.1.tar.xz"
  sha256 "c1cd7152519f4188591fa4f6ddeb116bc1004491f5f3c58aa99b00582eb8a137"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "6b90bc729b4a604182ed5ca63814c04e70e9a4e4b8a587005d621439f2a3a8a5"
    sha256 arm64_sequoia: "0e8c8aaf4c276db328923f58c1b1f836678ec862273290186b39202dd16a3842"
    sha256 arm64_sonoma:  "55dbc01236f1e41b102d2802592327abf96e89b7ab1d0e8d4b9b8a3594034dfe"
    sha256 sonoma:        "54bed3cca5c2cc1957230cb61f8d6b02bf12117357f9cdcf62c5da423066b3fc"
    sha256 arm64_linux:   "e0825144c9c45f897a22da0f2402252798fa03a1b709c5cec204457b38ed712f"
    sha256 x86_64_linux:  "4754e894c18796433fa57f4fa945b0a60143cf55cc9f4df8aa918da500048214"
  end

  depends_on "pkgconf" => :build
  depends_on "ca-certificates"
  depends_on "python@3.14"
  depends_on "sqlite"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1400
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  def python3
    which("python3.14")
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
