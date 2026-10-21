class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://github.com/nift-dev/nift/archive/refs/tags/v4.12.0.tar.gz"
  sha256 "5ed1468cefdc1b908f161a4492a74c9910618e10bcf8cbce5afb175c7ed378cd"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c637828ac075b284da3a44e49d96732652d9f3763eacadeee137ccf6edea3dae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eda0edbe84048db4e7c6751b23a4166c3ffabb9681e47447aedf96f1e3d9c149"
    sha256 cellar: :any,                 arm64_sequoia:     "e0552aea8f5e1d30fd7cc9ae2b64d7ebc213623a65940020dc8a8aa652424819"
    sha256 cellar: :any,                 arm64_linux:       "5592086e298322ca99b59b2e747e50ab788833ffcc28144648c9187edb68bcee"
    sha256 cellar: :any,                 x86_64_linux:      "fa97eee937ba78bb6be439fa2f0037485590c4ad724347c020b73b30e2ff5d6e"
  end

  uses_from_macos "python" => :build

  on_sequoia :or_older do
    depends_on "llvm"

    fails_with :clang do
      cause "floating-point `std::from_chars` requires macOS 26 libc++"
    end
  end

  deny_network_access!

  def install
    if OS.mac? && MacOS.version <= :sequoia
      # Link LLVM's libc++ as the system one lacks floating-point `std::from_chars` before macOS 26
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", formula_opt_lib("llvm")/"c++"
      inreplace "Makefile", /^CXXFLAGS \?= /, "\\0-D_LIBCPP_DISABLE_AVAILABILITY "
    end

    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"nift", "init", "--ext=.html"
    assert_path_exists testpath/"public/index.html"
  end
end
