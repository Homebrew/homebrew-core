class Dpp < Formula
  desc "Directly include C headers in D source code"
  homepage "https://github.com/atilaneves/dpp"
  url "https://github.com/atilaneves/dpp.git",
      tag:      "v0.6.0",
      revision: "9c2b175b32cc46581a94a7ee1c0026f0cda045fc"
  license "BSL-1.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86cb5490c0ddbbe4e7a242cafd4e776a243873dd649ec1e077b23e91e6cab1bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5f0fc9c62c460aba1532c7389e42c9bb85da0bcfa38607b76a361cb66c0d396"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49bf533852469130afaf24027a2d88f6825d35cd90515e041bdddccff3620640"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "443e5a65e5f70dc1c1af23f374c94cb1c6ff26836a4b23c9c6e4597502dbd060"
    sha256 cellar: :any_skip_relocation, sonoma:        "aebc8ca08df57de8624e9fb1a324872bb5883b207bb2a650a59125efc54e823b"
    sha256 cellar: :any_skip_relocation, ventura:       "8acb22136bec153dd078adc4ad53441ce33e65a1ad96c25161a13cc19ca9e1e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5115fc9b696c79b4acaa885bf0476915c91993d8a0ecfe393fd85cbd2b5af56d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2831967224ea98d7b494448db999203aead8f24183bb33319315f5af8d271185"
  end

  depends_on "dtools" => :build
  depends_on "dub" => :build
  depends_on "ldc" => [:build, :test]

  uses_from_macos "llvm" # for libclang

  # Match versions from dub.selections.json
  # VERSION=#{version} && curl https://raw.githubusercontent.com/atilaneves/dpp/v$VERSION/dub.selections.json
  resource "libclang" do
    url "https://code.dlang.org/packages/libclang/0.3.3.zip"
    sha256 "281b1b02f96c06ef812c7069e6b7de951f10c9e1962fdcfead367f9244e77529"
  end

  resource "sumtype" do
    url "https://code.dlang.org/packages/sumtype/1.2.8.zip"
    sha256 "fd273e5b4f97ef6b6f08f9873f7d1dd11da3b9f0596293ba901be7caac05747f"
  end

  resource "unit-threaded" do
    url "https://code.dlang.org/packages/unit-threaded/2.1.9.zip"
    sha256 "1e06684e7f542e2c3d20f3b0f6179c16af2d80806a3a322d819aec62b6446d74"
  end

  def install
    resources.each do |r|
      r.stage buildpath/"dub-packages"/r.name
      system "dub", "add-local", buildpath/"dub-packages"/r.name, r.version.to_s
    end
    # Avoid linking brew LLVM on Intel macOS
    inreplace "dub-packages/libclang/dub.sdl", %r{^lflags "-L/usr/local/opt/llvm/lib"}, "//\\0"

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
    system "dub", "build", "--skip-registry=all", "dpp"
    bin.install "bin/d++"
  end

  test do
    (testpath/"c.h").write <<~C
      #define FOO_ID(x) (x*3)
      int twice(int i);
    C

    (testpath/"c.c").write <<~C
      int twice(int i) { return i * 2; }
    C

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
