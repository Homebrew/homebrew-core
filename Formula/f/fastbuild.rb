class Fastbuild < Formula
  desc "High performance build system for Windows, OSX and Linux"
  homepage "https://fastbuild.org/"
  url "https://github.com/fastbuild/fastbuild/archive/refs/tags/v1.17.tar.gz"
  sha256 "f789b19468aaab0a8e2f013c42e3a53e2412c659948f007f15b46b4674ff5434"
  license "Zlib"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbd9879162332115fa642eeb6273dd839b520fce75914d69bd7ab1f0cd221c9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86e73216872ed41517e67d7f7abc234941ea7390c3c46bc7cd932e52932a6e50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b900fd9ba72673b94996abd308564e572f571828a892060435ab4239ba86bd15"
    sha256 cellar: :any_skip_relocation, sonoma:        "22e1f8b3227cd461b7d63671960e51945e629712bf0bafc549796348ad44b92c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccbdc2d506a0cdda24d4168923396570a3f29881fc76c4e863ad8bb86d903fa3"
  end

  on_linux do
    depends_on arch: :x86_64 # no bootstrap for arm64 Linux
  end

  resource "bootstrap-fastbuild" do
    on_macos do
      url "https://fastbuild.org/downloads/v1.16/FASTBuild-OSX-x64%2BARM-v1.16.zip"
      sha256 "b1267a0284cddf72db9d5fc89e10695ca3a56734f156f8d7f05d789359431109"
    end
    on_linux do
      url "https://fastbuild.org/downloads/v1.16/FASTBuild-Linux-x64-v1.16.zip"
      sha256 "691363548e1c1b2d0cda6ae1fbddb9efc9719688c05cc45acffbb49d37689a34"
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
