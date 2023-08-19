class Dpp < Formula
  desc "Directly include C headers in D source code"
  homepage "https://github.com/atilaneves/dpp"
  url "https://github.com/atilaneves/dpp.git",
      tag:      "v0.5.5",
      revision: "c74291190d5fe81ff23ec1d21290fd7047c256a9"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8200b30a5c22f48a57b405e8ce590e290cffd8f07fbc502b6bb18ecc358bb2f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2ecf24bc0fcff5d4096990f971d4e983bc35d359d312e89123da7d886d14123"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db600cf00396d5916f3ef95dfa5a110fabf4aa1b002104ca00c0a3eb844b3954"
    sha256 cellar: :any_skip_relocation, ventura:        "b9cad2da102dbb1911107e26b89c57259aa9ea3dee09049e3dcbceb87dc8f7b1"
    sha256 cellar: :any_skip_relocation, monterey:       "b586c87b08bc7168af973c9ab28f3b61cce69ad71b3274b5032959a0cdb099a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "fefa9a0975985b6a9a7b5df27279df35382f44b091ead310ac898bb0fabc515a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b01ee202e3bf70bb66304fc20566d2140a565daeb65a6f4386babc2fcb065990"
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
