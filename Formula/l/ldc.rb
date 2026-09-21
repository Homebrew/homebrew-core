class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.43.0/ldc-1.43.0-src.tar.gz"
  sha256 "d655aad0daf0ce9a17b2ffffb947bb79ec6968bc7fb88bc918316dbe78c616e7"
  license "BSD-3-Clause"
  head "https://github.com/ldc-developers/ldc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256               arm64_golden_gate: "86e72c71c5005de997703e774cf06b240ed740b73d13a24cff61c35fc9f24412"
    sha256               arm64_tahoe:       "6411351b3cc448579fe425e82d585065fb9110066bd2dca38403d62255ae44aa"
    sha256               arm64_sequoia:     "df52a126dd7cfa567931c844773425000f5fad054d041ba17873723ed7dde8b2"
    sha256               arm64_sonoma:      "8b77efb73179e35cbe3f0c0cac3ec27f3d21e80e92aea40042b67fc90a0406b6"
    sha256               arm64_linux:       "c3a37bb1b0bdb6dc779c5c76e1758ddd9b8b0d19a5dd8c950da2b249c2bcf75f"
    sha256 cellar: :any, x86_64_linux:      "9c53afa35a0a50ccf3a47e5a502e8cf4289102dc69067cfc36425b8a7313566a"
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
