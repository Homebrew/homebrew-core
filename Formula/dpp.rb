class Dpp < Formula
  desc "Directly include C headers in D source code"
  homepage "https://github.com/atilaneves/dpp"
  url "https://github.com/atilaneves/dpp.git",
      tag:      "v0.5.4",
      revision: "28a52fb2c761aae3a84ab8456c8fba31d92b564d"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03ca15da1c96a706ee55ce7bba27e59bd539b46d82ca74941adf2276477b1c6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf29deb10577ff69d3c373ec5bbe0b813058ded6d8506e2764d37e687ab8bf3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfc47d85120f00e295d49d156a3bf4fca559a5720532f7d632ff0063f36df079"
    sha256 cellar: :any_skip_relocation, ventura:        "d994219c6549ca43b313c9cdc79789b03eee5038c864c36f6cdc15308e52ad66"
    sha256 cellar: :any_skip_relocation, monterey:       "621a3411ec9bc931af99dfc018e58c3b2bd8a7eb1e60ffc7b0964a50f380c7f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "9326e11612ceaca85fd0939a59b5c6e93b7a272190d1d9977e0b0d9c28eab08c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d7911af3690bdcf446cbaab3d8e244462e9151cf2752bc85b6ae74aa5aefe96"
  end

  depends_on "dtools" => :build
  depends_on "dub" => :build
  depends_on "ldc" => [:build, :test]

  uses_from_macos "llvm" # for libclang

  # Match versions from dub.selections.json
  resource "libclang" do
    url "https://code.dlang.org/packages/libclang/0.3.2.zip"
    sha256 "c54c01b65f2a62c93a2929c4d7acee05ed502d841839bf9f4c212e5d18ded137"
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
