class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.42.0/ldc-1.42.0-src.tar.gz"
  sha256 "9bb0f628f869f7fc7b53c381a79742d29c17552c6f1a56b0a02aa289e65a0e3b"
  license "BSD-3-Clause"
  head "https://github.com/ldc-developers/ldc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "d991984a75a3d4e16e768ac1696cc01c65893a07f226b70160900ef280e5f2ae"
    sha256                               arm64_sequoia: "b16cde9d20ef2b46b10a7469e87ef397ce0cd6182510671ef530d692233900b9"
    sha256                               arm64_sonoma:  "81c19ed1da2c4bc40d5b97143bbcdcb8d54dfb082ff3cd67851573cc4323035c"
    sha256                               sonoma:        "e89dbaa17a1734c3de7d83c21c9e830db35a2a65316f19dec04f14258359d598"
    sha256                               arm64_linux:   "fcd364ba774b8952ca6e37217a458079a381cf2f3e585eefb73c20afc59e808b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64399cdbbf80a94468e00ab0ea0377b835776da4513307b8e2b3d9f6afaa5a7d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "lld@21" => :test
  depends_on "llvm@21"

  resource "ldc-bootstrap" do
    on_macos do
      on_arm do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.41.0/ldc2-1.41.0-osx-arm64.tar.xz"
        sha256 "157267042f10b047210619314aa719b4f0bf887601e93b1c634aa1ecb3c546e4"
      end
      on_intel do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.41.0/ldc2-1.41.0-osx-x86_64.tar.xz"
        sha256 "5bcff48b63c56a45dbaacdb0c5bddc8ea6be86d4a0c7b2c7c8318e047f721181"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.41.0/ldc2-1.41.0-linux-aarch64.tar.xz"
        sha256 "1c4b950a13d53379ed4f564366c27ec56d6261e21686880d70c7486b3e8c7ba8"
      end
      on_intel do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.41.0/ldc2-1.41.0-linux-x86_64.tar.xz"
        sha256 "4a439457f0fe59e69d02fd6b57549fc3c87ad0f55ad9fb9e42507b6f8e327c8f"
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
