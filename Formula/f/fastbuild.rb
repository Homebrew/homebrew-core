class Fastbuild < Formula
  desc "High performance build system for Windows, OSX and Linux"
  homepage "https://fastbuild.org/"
  url "https://github.com/fastbuild/fastbuild/archive/refs/tags/v1.18.tar.gz"
  sha256 "9668d332ecb74303687680b6156caa6b9684db1dfbe9ce8b6846efdbb74ba4c4"
  license "Zlib"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c36a4eb0c8ae858019a2fb9e0d87ed959b797d47588146d07feae2d7985d00d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c36a4eb0c8ae858019a2fb9e0d87ed959b797d47588146d07feae2d7985d00d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97d696bc97ef2e2e0d3b26b564f27de271616e0dfdad8fa2232e1fc437f18a6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bf8d41d64fa38161ed37abaa6bfb6284f252522be9ec63d079454b73c0d0a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f8952ebabac5d3906df56a549abc5ddea24d851ffd53e99b73749af4fc79c73"
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
