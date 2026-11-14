class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-3.14.1.tar.xz"
  sha256 "5b85cba0f014d344eb8e9919aee0a3bdc31e16acb05816410025be9bee1e0930"
  license "BSD-2-Clause"
  compatibility_version 4
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "71c89d76ef109ad7eb1af4c7ff2bfb4a45594ad6642f46530d84d0ac2c282ae2"
    sha256 arm64_tahoe:       "54de75c5085c7cb53e1dbd60d4942f933d6a99c3ffeef31bdfe53811a509e4f1"
    sha256 arm64_sequoia:     "9abc6beedca224c8dd2759e65587ceea67614df645810f6272ee47f0b058e635"
    sha256 arm64_linux:       "5fb1ffd5b8b05896ff9ce42f8dcca7bb274c9f06b06c751f340b986cb1ada711"
    sha256 x86_64_linux:      "16452aad4ecf9bc4bbaae5a3172ccc9f0712fe81516edb0f6407bcd792a26aac"
  end

  depends_on "pkgconf" => :build
  depends_on "python@3.15" => [:build, :test]
  depends_on "ca-certificates" => :no_linkage
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

  deny_network_access!

  def install
    ENV.runtime_cpu_detection

    python_formula = Keg.for(python3).to_formula
    python_versions = [python_formula, *python_formula.versioned_formulae].map(&:version).select { |v| v >= "3.12" }

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --with-zlib
      --with-bzip2
      --with-python-versions=#{python_versions.map(&:major_minor).join(",")}
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
    system python3, "-c", <<~PYTHON
      import botan3 as botan
      r = botan.RandomNumberGenerator()
      phash = botan.bcrypt('testing', r)
      assert(phash.startswith("$2a$"))
      assert(botan.check_bcrypt('testing', phash))
    PYTHON
  end
end
