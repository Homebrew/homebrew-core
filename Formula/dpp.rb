class Dpp < Formula
  desc "Directly include C headers in D source code"
  homepage "https://github.com/atilaneves/dpp"
  url "https://github.com/atilaneves/dpp.git",
      tag:      "v0.4.12",
      revision: "06a340250792eac4bb3c7ff2661cc76e1e75b5c7"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0658eee6e138e9930ae0054affcea76cb33f2edccd0c226520eddef3f06bdb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ae3e6950689244e4f8a8af145253c5239579a311d75916d2f9ab0563cfb0a73"
    sha256 cellar: :any_skip_relocation, monterey:       "1b712e76dbe96b358290d5b20723ba782dac9a0d7a96563d6ea9df08f5f7a31d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f8679bce1298ac64c819afe9206dd4bf96db147c9a386e1df1433f25b95bd9a"
    sha256 cellar: :any_skip_relocation, catalina:       "f5db719e6d8e3c89f84057ec6b20a055bbeabad778c44f156f7b1d6c5d114b63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff41dddefb361e9525f2aab7498711e21048420fb017cd537347fd8bdb8d59c6"
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
