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
    rebuild 1
    sha256 arm64_golden_gate: "22553306185fc848e81c7e88c5df5954e0dcf22e1841f089e911cfeaaaa309a7"
    sha256 arm64_tahoe:       "172d81cf6d6958ee819bb5576f15e39a55ad4a832f653c71fa9f09ee408a2e44"
    sha256 arm64_sequoia:     "8900beebc0493371a6fde3b7b78d4941ae839f732c0c681be02d52debdd38507"
    sha256 arm64_linux:       "392fb0efdde799208c755a4506e4482289457531858489657cce41e32d73ed4a"
    sha256 x86_64_linux:      "07f24225875cf8133295f25db4a514cca408aa2dbcbacf7d6e443ee487d000f6"
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
