class Fastbuild < Formula
  desc "High performance build system for Windows, OSX and Linux"
  homepage "https://fastbuild.org/"
  url "https://github.com/fastbuild/fastbuild/archive/refs/tags/v1.15.tar.gz"
  sha256 "c08d9233d575d6dbbc42363caa64e16cd9709e22f58b492dc1b65620fbdfc297"
  license "Zlib"

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "61c25b4f9dbf1cdd1956a23a46ead3d306fa029825312ed88dee6a6849e5d5b0"
    sha256 cellar: :any_skip_relocation, ventura:      "f2ed6f7c462b3a7d23fe9e5e7c63c049fc343b56df292c0e91f69e5587146930"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "64bf2acdbf4398851da98943e21cd69a6549464e16178b3ce4c8746188dc48d1"
  end

  on_linux do
    depends_on arch: :x86_64 # no bootstrap for arm64 Linux
  end

  resource "bootstrap-fastbuild" do
    on_macos do
      url "https://fastbuild.org/downloads/v1.13/FASTBuild-OSX-x64%2BARM-v1.13.zip"
      sha256 "290e60e0c3527c3680c488c67f1c7e20ca7082d35e38664cd08ca365d18b46fe"
    end
    on_linux do
      url "https://fastbuild.org/downloads/v1.13/FASTBuild-Linux-x64-v1.13.zip"
      sha256 "0aede5c4963056bd90051626e216ca4dfcc647c43a082fab6f304f2d4b083d6e"
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
