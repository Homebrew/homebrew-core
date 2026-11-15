class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.43.0/ldc-1.43.0-src.tar.gz"
  sha256 "d655aad0daf0ce9a17b2ffffb947bb79ec6968bc7fb88bc918316dbe78c616e7"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/ldc-developers/ldc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256               arm64_golden_gate: "6f0db0e8746ee72a56154895c8288f7db17e42038b1663b793c9169480f8d021"
    sha256               arm64_tahoe:       "9627b92b0980704d1b46c0417297a8d09cb9fa37c81a24586350c4110366b930"
    sha256               arm64_sequoia:     "ee5fda073ef5e128f7094188fdbf7414cfc068dda94add93154f3cec30fdea0a"
    sha256               arm64_linux:       "8e6bf0c42cc525fcac4ca2990a2ee1960e98101daa0383566cb001f44150c269"
    sha256 cellar: :any, x86_64_linux:      "1538153ae6535eade9e8042e884f1de377ceb2bb7cbb3f5c51c958feed34c193"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "lld" => :test
  depends_on "llvm"

  resource "ldc-bootstrap" do
    on_macos do
      on_arm do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.42.0/ldc2-1.42.0-osx-arm64.tar.xz"
        sha256 "7a68e21c5305766a74f4736cc891a7942db7842a9226623209504bc85c701382"
      end
      on_intel do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.42.0/ldc2-1.42.0-osx-x86_64.tar.xz"
        sha256 "3d3d4283c2f0856f65aca4af3c1e14d25f12619808893ca755ea6f088508503e"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.42.0/ldc2-1.42.0-linux-aarch64.tar.xz"
        sha256 "687707c3e20ff910528eb2d92f27a98cb0960284de3b026e6bf20284ac1c8511"
      end
      on_intel do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.42.0/ldc2-1.42.0-linux-x86_64.tar.xz"
        sha256 "a7bc9c956138f558cadf9c962352f59d41c80df6eb3ae3f8039f25be14a69303"
      end
    end
  end

  def llvm
    deps.reject { |d| d.build? || d.test? }
        .map(&:to_formula)
        .find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    (buildpath/"ldc-bootstrap").install resource("ldc-bootstrap")

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DD_COMPILER=#{buildpath}/ldc-bootstrap/bin/ldmd2
      -DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc
      -DLLVM_ROOT_DIR=#{llvm.opt_prefix}
      -DCOMPILER_RT_BASE_DIR=#{llvm.opt_lib}/clang
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.d").write <<~D
      import std.stdio;
      void main() {
        writeln("Hello, world!");
      }
    D
    system bin/"ldc2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    lld = deps.map(&:to_formula).find { |f| f.name.match?(/^lld(@\d+(\.\d+)*)?$/) }
    with_env(PATH: "#{lld.opt_bin}:#{ENV["PATH"]}") do
      system bin/"ldc2", "-flto=thin", "--linker=lld", "test.d"
      assert_match "Hello, world!", shell_output("./test")
      system bin/"ldc2", "-flto=full", "--linker=lld", "test.d"
      assert_match "Hello, world!", shell_output("./test")
    end
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
