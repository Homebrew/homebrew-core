class Dpp < Formula
  desc "Directly include C headers in D source code"
  homepage "https://github.com/atilaneves/dpp"
  url "https://github.com/atilaneves/dpp.git",
      tag:      "v0.4.13",
      revision: "a29b2931cfc9c43fd2cc29a9795d6a0b2e5c2e39"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db424cf9c108a38fe50597513f26f187df360d990f55e6f74b9153c6a85cd13a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efdbbd1136c6320364b15692437dcce9f283f82810eb392595c3440ae8bed034"
    sha256 cellar: :any_skip_relocation, monterey:       "89d15859ef732a88df7c91281f1af81baa5b783e4248baddec50918b7b365e82"
    sha256 cellar: :any_skip_relocation, big_sur:        "46be70b12a9fd3103c32dfedbe0ef3f2c71b7bfe5c957dc70ef59f7672a9dc6f"
    sha256 cellar: :any_skip_relocation, catalina:       "010a0bc89e3e7193e13260a23dcf223a77c5b84f0902c53e57345d2ace0d243f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa2b435911b3a960d25543fe31898d48ffebb7b268fa2423456e8a7c3b9c3f1d"
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
