class Dpp < Formula
  desc "Directly include C headers in D source code"
  homepage "https://github.com/atilaneves/dpp"
  url "https://github.com/atilaneves/dpp.git",
      tag:      "v0.4.9",
      revision: "55daf91e2c180962de783752b3e4447850b7a151"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8182f39dd5d437d3704903bf3e900a9db79980030255bdc86c6b9a1ce8124098"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e527f94488f2776f2a9d605effeb2e14fc1db06874e04fd13a9c1863a94865b3"
    sha256 cellar: :any_skip_relocation, monterey:       "5bcdf980f6e8e6154b84fd319f8b3b0510149b488f3c538a4e308dea7959e4c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "94fac3f313d7813a69b899e1d93d025057b7fcc0f8e3eba7c01beae24c38b12a"
    sha256 cellar: :any_skip_relocation, catalina:       "6c6f6792761d194d1494aa259b7fad1b16aac44c7ba2dd21f461c711441a17a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6938126d05a91fb9d0fa3bb9ab3e98dd830c615a253404ca021c3d9780fb50c"
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
