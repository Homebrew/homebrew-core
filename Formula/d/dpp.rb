class Dpp < Formula
  desc "Directly include C headers in D source code"
  homepage "https://github.com/atilaneves/dpp"
  url "https://github.com/atilaneves/dpp.git",
      tag:      "v0.6.0",
      revision: "9c2b175b32cc46581a94a7ee1c0026f0cda045fc"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b9bac32440464a7d775ef641fff284d5de50ab7ecf6c1ad37e3a137898435504"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2476590c375c79bc2b694bf10a2edd7721d3603f7738b8d6c935d487ac9655f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a55479222fdfcb5350b7a06f509ce37a7af58d6b2f0c36807a3250b0a3169618"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56f17de3bca828d4d844a811f40ed824827876530e8c4f3bef427c1f1c934678"
    sha256 cellar: :any_skip_relocation, sonoma:         "a342da9f8b506999916e8ab83b6a0b7ca1574852e5daa106d4eb5308b1f4e588"
    sha256 cellar: :any_skip_relocation, ventura:        "cff6526644d8ebdf667ad74b1ef8c420bf76014f0dd57b05bf9706f45efba495"
    sha256 cellar: :any_skip_relocation, monterey:       "0dea447606ae46a62481252ea7cd16c2a6545be69918abea6949c787b55c39b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac1f792f0814d1b5b07b10b751308dd7efc34f7105f93fc27946d3a649857db4"
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
