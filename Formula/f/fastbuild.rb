class Fastbuild < Formula
  desc "High performance build system for Windows, OSX and Linux"
  homepage "https://fastbuild.org/"
  url "https://github.com/fastbuild/fastbuild/archive/refs/tags/v1.19.tar.gz"
  sha256 "a0014ce2f3c31ee1db21883151141a2633739f8147fb6b9888603f423fccec56"
  license "Zlib"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a95661f3b3667aeb271bc2eca4ab45c748fa6414684be88ec151ecd0df6feb73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a95661f3b3667aeb271bc2eca4ab45c748fa6414684be88ec151ecd0df6feb73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9639b58016ff7672f5fa76a7023cd00bf392bf7f2a33cbec745e8c90ad200428"
    sha256 cellar: :any_skip_relocation, sonoma:        "9588121fcfcf5433ce1b0357df57b80407a97885198003c4dd9949bde471b69c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7374315d541cf5b53077ef653910e6d76bb1e6a3b7ae4c5c28e1e638808fb54f"
  end

  on_linux do
    depends_on arch: :x86_64 # no bootstrap for arm64 Linux
  end

  resource "bootstrap-fastbuild" do
    on_macos do
      url "https://fastbuild.org/downloads/v1.17/FASTBuild-OSX-x64%2BARM-v1.17.zip"
      sha256 "66ac01d8aa2e04f7a9c4870fdb7ef79674473462a0dde818768b67c25eaa893b"
    end
    on_linux do
      url "https://fastbuild.org/downloads/v1.17/FASTBuild-Linux-x64-v1.17.zip"
      sha256 "cbaae008fad417339734a32e24180958d5f0df640bc324d2b976cdb9dc97f2ac"
    end
  end

  def install
    resource("bootstrap-fastbuild").stage buildpath/"bootstrap"
    fbuild = buildpath/"bootstrap/fbuild"
    chmod "+x", fbuild
    # Fastbuild doesn't support compiler detection, see
    # https://github.com/fastbuild/fastbuild/issues/511
    # and https://fastbuild.org/docs/functions/compiler.html
    inreplace "External/SDK/GCC/GCC.bff", /(?<=#define )USING_GCC_9/, "USING_GCC_11" if OS.linux?

    os = OS.mac? ? "OSX" : "Linux"
    arch = Hardware::CPU.arm? ? "ARM" : "x64"
    host = "#{arch}#{os}-Release"

    cd "Code" do
      system fbuild, "All-#{host}"
    end
    %w[FBuild FBuildWorker].each do |t|
      bin.install "tmp/#{host}/Tools/FBuild/#{t}/#{t.downcase}"
    end
  end

  test do
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main(void) {
        printf("Hello\\n");
        return 0;
      }
    C
    (testpath/"fbuild.bff").write <<~BFF
      .CompilerInputPattern = '*.c'
      .Compiler = '#{ENV.cc}'
      .CompilerOptions = '-c "%1" -o "%2"'
      .Linker = '#{ENV.cc}'
      .LinkerOptions = '"%1" -o "%2"'
      ObjectList( 'HelloWorld-Lib' )
      {
        .CompilerInputPath  = '\\'
        .CompilerOutputPath = '\\'
      }
      Executable('HelloWorld')
      {
        .Libraries = { 'HelloWorld-Lib' }
        .LinkerOutput  = 'hello'
      }
      Alias('all') { .Targets = { 'HelloWorld' } }
    BFF
    system bin/"fbuild"
    assert_equal "Hello", shell_output("./hello").chomp
  end
end
