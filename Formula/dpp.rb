class Dpp < Formula
  desc "Directly include C headers in D source code"
  homepage "https://github.com/atilaneves/dpp"
  url "https://github.com/atilaneves/dpp.git",
      tag:      "v0.4.10",
      revision: "40ab857b7159268800c72d3de6242c4568f5e177"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d6c36df683ebeca1cd109cc8d92417ec4c3dae163ab1cd7ea295e3b4458d534"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc9ef5f553341fcc1f2c6bee5baf3277bf6b89e73f9d00e66b76e05d314142a7"
    sha256 cellar: :any_skip_relocation, monterey:       "bd1432ca96e3fe054b029645998e959471fddf1c614a105b46c7b29647b60f95"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2aaffc50922f19a32841a49ff9b0dd75e35bbc4d3184aee303757ac1140c0ad"
    sha256 cellar: :any_skip_relocation, catalina:       "f3ac91b1014d225c2a6028d01487f375a456ca495bba146b38e778a30621c2d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edf62503deb31c840ff905ac369ab4ae7e82c83582c76464d2a7f8b86a1abf9c"
  end

  depends_on "dub" => :build
  depends_on "ldc" => [:build, :test]

  uses_from_macos "llvm" # for libclang

  def install
    if OS.mac?
      toolchain_paths = []
      toolchain_paths << MacOS::CLT::PKG_PATH if MacOS::CLT.installed?
      toolchain_paths << MacOS::Xcode.toolchain_path if MacOS::Xcode.installed?
      dflags = toolchain_paths.flat_map do |path|
        %W[
          -L-L#{path}/usr/lib
          -L-rpath
          -L#{path}/usr/lib
        ]
      end
      ENV["DFLAGS"] = dflags.join(" ")
    end
    system "dub", "add-local", buildpath
    system "dub", "build", "dpp"
    bin.install "bin/d++"
  end

  test do
    (testpath/"c.h").write <<~EOS
      #define FOO_ID(x) (x*3)
      int twice(int i);
    EOS

    (testpath/"c.c").write <<~EOS
      int twice(int i) { return i * 2; }
    EOS

    (testpath/"foo.dpp").write <<~EOS
      #include "c.h"
      void main() {
          import std.stdio;
          writeln(twice(FOO_ID(5)));
      }
    EOS

    system ENV.cc, "-c", "c.c"
    system bin/"d++", "--compiler=ldc2", "foo.dpp", "c.o"
    assert_match "30", shell_output("./foo")
  end
end
