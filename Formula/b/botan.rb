class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-3.13.0.tar.xz"
  sha256 "12f5a8358890bbee82edfe9d2e7769b0a610b6dd0e0698aea13d20a675d84620"
  license "BSD-2-Clause"
  compatibility_version 3
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "772694ed0fa9b6b0b7485e1ee6772cc3605fcad2605f6c312ea6768056846d8b"
    sha256 arm64_sequoia: "624d3920b982a37290cd5111230ae0da8ddfc0693e9c47392ceb454973140435"
    sha256 arm64_sonoma:  "dcc157679f64f323e9070ce9f34026d5ace2319a713cae3594307cda5a0b89a5"
    sha256 sonoma:        "b1c30c3273b0b1663045b350c9d6420e643e40f4db74106e0c5abb9cfa12ea4f"
    sha256 arm64_linux:   "249a35ff5fd21acad1a9c5470c89d77eb384fce407757e8518592b6585e1b8e5"
    sha256 x86_64_linux:  "1ec44df72694f1fbc8b6f3bfa65a9ac5f1f237e9ef5cf81158326383232b8984"
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
      ldflags = %W[-L#{formula_opt_lib("llvm")}/c++ -L#{formula_opt_lib("llvm")}/unwind -lunwind]
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
