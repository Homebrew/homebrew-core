class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-3.14.0.tar.xz"
  sha256 "c22d66a08cd3c6dae683bdcb8384beaa9e2cbd75821e19a270047030fbe81ac7"
  license "BSD-2-Clause"
  compatibility_version 4
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "fb4bc84bc613583dfe099d135ea720bbe41d85851ce56ce53db5a2a7dc515925"
    sha256 arm64_tahoe:       "dcf729a1ae09a236017c146480d8d8a3e06c1eff4cc5a4a31a3448e3be748f90"
    sha256 arm64_sequoia:     "77ccdc730f456dd4d7d37debbba457065be490a4fadbceeb3c994e279348c61a"
    sha256 arm64_linux:       "b54a5f1e8b270ae2183e9b5f0dcce49f98a213d86f89ca1c4fd60a70497f19d2"
    sha256 x86_64_linux:      "7bf26ce8360df5e15ea1998e11609e64bbe4487ed7965dfd69b59f2013ca8475"
  end

  depends_on "pkgconf" => :build
  depends_on "ca-certificates"
  depends_on "python@3.15"
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
    if OS.mac?
      args << "--with-commoncrypto"
      # The CLI's `sandbox_init` profile constants were removed from the macOS 27 SDK
      args << "--without-os-features=sandbox_proc"
    end

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
