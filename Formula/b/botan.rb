class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-3.5.0.tar.xz"
  sha256 "67e8dae1ca2468d90de4e601c87d5f31ff492b38e8ab8bcbd02ddf7104ed8a9f"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "f8cb0f5126bac257ae499c377416d67e016f41cb91eb4f781dfba7ead772b27b"
    sha256 arm64_sonoma:  "4a8bd22f2016573a9252590843e637b6db8d346babaa2e755202c6e12ded6020"
    sha256 arm64_ventura: "1f368b18ba1f404edf279c8c84d8dd34167209dcd356a95c005d49dcb11a034a"
    sha256 sonoma:        "ec4c0d57a43c4de2c5505feb354f7dab477b531f548afa1dac31fce1c52060b3"
    sha256 ventura:       "5f68a7023c8a8bac60d1cb785457620dc5c47a6163e55432de02c5029fdbd280"
    sha256 x86_64_linux:  "4e0fb5e03509bb2e3a29830c5271a34e08ec6e4bd88ed4993f58e04db96dedd2"
  end

  depends_on "pkg-config" => :build
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

  fails_with gcc: "5"

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
