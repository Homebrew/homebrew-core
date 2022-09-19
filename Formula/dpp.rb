class Dpp < Formula
  desc "Directly include C headers in D source code"
  homepage "https://github.com/atilaneves/dpp"
  url "https://github.com/atilaneves/dpp.git",
      tag:      "v0.4.11",
      revision: "4c66d7959917f8440970ac447129b7b9f691dbc0"
  license "BSL-1.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c2eb7cfae10d78fb99ea1290ea1bbc58751603aef67e18f88279a4fec36dbdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8eca82d866ab06ee607cf656e7ae85ce5071aa9b1a2667ab5dd6194714b2b58f"
    sha256 cellar: :any,                 monterey:       "7f366f783ee50fe0a49f4bb2e06c6243346c100d310974dd87690f854c4cb315"
    sha256 cellar: :any,                 big_sur:        "adf314b02d371dae57b5c39a5c2b64d29e055191aa4c2e57779d330327e007c6"
    sha256 cellar: :any,                 catalina:       "3a4d4faf920f4e24d4169caadd7947dc99fe7a53ea4660da93de5f9908d158fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfa73022f3ae3ba09c62df22a02cbb9faf54e9abb662babc0c5654baa45d5dcb"
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
