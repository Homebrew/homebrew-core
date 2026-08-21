class Fastbuild < Formula
  desc "High performance build system for Windows, OSX and Linux"
  homepage "https://fastbuild.org/"
  url "https://github.com/fastbuild/fastbuild/archive/refs/tags/v1.20.tar.gz"
  sha256 "62dc242dee1f6604d979c162b23f728583d94fd5ba834eecd86e39591a10b0e4"
  license "Zlib"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b53e07d404e86d3bc520ad354735640bb580eaf7a60432f51c7fc8b20191b6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d2505f55b7703a8894a18b923bc8f01357a9835d688c9750fa6d1f788bba103"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3b8da658317fbf90877abe1fdc62b808def4169ee5a6145471f38162b9118d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "26c53185596e48f39d1cc05c712fd45664635f77df6b0cd7d2928e3d70c4a658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "366aead21d61aab757949f06ff4ebeed4e25611542b483390600f52ac630a750"
  end

  on_linux do
    depends_on arch: :x86_64 # no bootstrap for arm64 Linux
  end

  resource "bootstrap-fastbuild" do
    livecheck do
      url "https://fastbuild.org/downloads/"
      regex(/v?(\d+(?:\.\d+)+)/i)
    end

    on_macos do
      url "https://fastbuild.org/downloads/v1.20/FASTBuild-OSX-x64%2BARM-v1.20.zip"
      sha256 "acbb5392b1aecf882866f1d396ea3b1e7184b5176473c7ddbd9bd8196d2520c5"
    end
    on_linux do
      url "https://fastbuild.org/downloads/v1.20/FASTBuild-Linux-x64-v1.20.zip"
      sha256 "a5de81c736f9e23900b9aec7dd668a15abeeb39e4345992e66810d6ea95d4a45"
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
