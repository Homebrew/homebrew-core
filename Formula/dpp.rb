class Dpp < Formula
  desc "Directly include C headers in D source code"
  homepage "https://github.com/atilaneves/dpp"
  url "https://github.com/atilaneves/dpp.git",
      tag:      "v0.4.14",
      revision: "efcdeece9e577504e1cc2438da10a136901b914f"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "369795c21bba3228030746cd649a83fc679f4f87b75525afef3bd132d1114699"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64a22e941ed8457d3075a74838dc964573330f68ea8b68e82c7538dc95557316"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a35bfe8f975383dee33e9ac42ec9b059976bc882df30355e6ef304be5ea264cc"
    sha256 cellar: :any_skip_relocation, ventura:        "a5374d874c00ef9401423a1da133736236e9534f9f21fcb923fff7e8a6f1e4bd"
    sha256 cellar: :any_skip_relocation, monterey:       "c7ccc222bf26054e503d1740de0a13056b4f5f1d25350045e55f25aa54d9ad87"
    sha256 cellar: :any_skip_relocation, big_sur:        "a15d9d85cc4fa8306be57a9f3edd5f069dc8e91449cef5fc971d68c6e5853726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d4667872ae69547c1c7afe2ce4484e4d64553fd0d06870378520dfafcd895f4"
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
