class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-3.12.0.tar.xz"
  sha256 "5370f98dc15f8c222ee1ce52cd61c8756a53be0dc57cc4c1b0714d5a09ad74fb"
  license "BSD-2-Clause"
  compatibility_version 2
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "9ddb5e41836f07812c3cbcbcff97dfbe697cc00b5ef487ed0409805e1924b7ea"
    sha256 arm64_sequoia: "32d5544145938712b7e244f4eee39337f3ae6de5a8c63cdce158feef47fc499b"
    sha256 arm64_sonoma:  "7ce2d41fe53a97b9a36aaf8d1575d04a3b50059e589cfb82a036e845b4edf91d"
    sha256 sonoma:        "f45621da8b9a3f4f30d8db8780cc35e008e7ed7f6c95fffa58d828c85adbd0bd"
    sha256 arm64_linux:   "93fcae01df8a7ab116b7d3c1358f49ba0b6fcd7f74261df2064eda2ffdd618cb"
    sha256 x86_64_linux:  "279875db014e61a9a0aa35931538602a57fe38c0b3e8f73b3dd00738057115aa"
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
