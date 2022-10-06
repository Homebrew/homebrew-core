class Dpp < Formula
  desc "Directly include C headers in D source code"
  homepage "https://github.com/atilaneves/dpp"
  url "https://github.com/atilaneves/dpp.git",
      tag:      "v0.4.12",
      revision: "06a340250792eac4bb3c7ff2661cc76e1e75b5c7"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da4b8359d7e016ec880089a9b28800b363553af2a9c54de34b6887df092b08b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28f05c69e09240046206dc0a28743f7ab060bfe833290f6a2a67a41712aa601a"
    sha256 cellar: :any_skip_relocation, monterey:       "428a66c01b7940ed0d32541fd016d9d8ff17e3cf0f2c309c7ff65bc001df9e12"
    sha256 cellar: :any_skip_relocation, big_sur:        "43cc9c9c63f3a07dfb756dab9c387e6b64b3a59d8c6f64ff6f36a38ab22cc02c"
    sha256 cellar: :any_skip_relocation, catalina:       "0fa0e83c5e676237d16bcaa80251f000bb0df19ce768fb7c7db2b6cc3500f8e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cf56aabe53afae0178dafc765d4e99dbe8668ac24d8347868ddc2a7f916c57e"
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
