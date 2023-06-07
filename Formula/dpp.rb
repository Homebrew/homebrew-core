class Dpp < Formula
  desc "Directly include C headers in D source code"
  homepage "https://github.com/atilaneves/dpp"
  url "https://github.com/atilaneves/dpp.git",
      tag:      "v0.5.2",
      revision: "1c42ced86f170f2961f948e66c9d8c01816b9186"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e280202742cf0f7638522705ee8f08db2ff597833653a8a73d9f2a2375c1e4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd2c953f61f3759db232ed0e859ec826f630ef3ea1eb45d51e63f85373e915d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b54f48a15f0d68462e8c349a6e6a3165ad8e8ea9d6c84dfab5bdbf0bd09d4153"
    sha256 cellar: :any_skip_relocation, ventura:        "d1c0447bfa9f2f6769e71f5282690725284b432130de74f7bb431bf17b7e1964"
    sha256 cellar: :any_skip_relocation, monterey:       "1dff146e0fb807a9367a286417740096c5efca2252e9e93f0cd33ca851536b28"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a473ed20de0d342da6f94e1a2529c3e59bc0ceae1c86cb03564d7fce0faa400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81e7cd49005ecf7943d927fb8c100eeb3f49107cbcaea0f6ff708e640e348d45"
  end

  depends_on "dtools" => :build
  depends_on "dub" => :build
  depends_on "ldc" => [:build, :test]

  uses_from_macos "llvm" # for libclang

  # Match versions from dub.selections.json
  resource "libclang" do
    url "https://code.dlang.org/packages/libclang/0.3.1.zip"
    sha256 "ff6c8d5d53e3f59dbb280b8d370d19cb001e63aad6da99c02bdd2b48bfb31449"
  end

  resource "sumtype" do
    url "https://code.dlang.org/packages/sumtype/0.7.1.zip"
    sha256 "e27e026505bd9a7eb8f11cda12a3030c190a3d93f6b8dccfe7b22ffc36694e4e"
  end

  resource "unit-threaded" do
    url "https://code.dlang.org/packages/unit-threaded/2.1.3.zip"
    sha256 "bb306506cc69f51e3ff712590c9ce02dba16832171d34c0a6243a47ba4a936d6"
  end

  def install
    resources.each do |r|
      r.stage buildpath/"dub-packages"/r.name
      system "dub", "add-local", buildpath/"dub-packages"/r.name, r.version
    end

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
