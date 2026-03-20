class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-3.11.0.tar.xz"
  sha256 "e8dd48556818da2c03a9a30932ad05db9e50b12fec90809301ecc64ea51bd11e"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b951023db73e163795e4e9de06c97115a7310ad81b83a86946bba69b814cd63b"
    sha256 arm64_sequoia: "d0213464a6901da5b6913aadcfa3dfbd7b5d9409c6217a2390960682c3e7b367"
    sha256 arm64_sonoma:  "73a2205ec78983904afc1bb0888697bf9e3331c06fe97a5971948cac98941154"
    sha256 sonoma:        "3d3ed734dbcff42369741c60667f9fe0175043ed6a9963175f3a8f868875b33f"
    sha256 arm64_linux:   "0ded61488f0792e4c81a944a9c50509af9d3f8be4794c78295eee695cedd8b19"
    sha256 x86_64_linux:  "f74d00ab242caab4b3b78c41817356ad16c8cab31b2c78f17cf7070c011f7231"
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
