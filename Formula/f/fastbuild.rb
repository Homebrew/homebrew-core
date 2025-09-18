class Fastbuild < Formula
  desc "High performance build system for Windows, OSX and Linux"
  homepage "https://fastbuild.org/"
  url "https://github.com/fastbuild/fastbuild/archive/refs/tags/v1.16.tar.gz"
  sha256 "acb1025eebc3967ad7e3bfd3e13fa4efe0a7d54aedcadd61ebeb9bff65c6cd5f"
  license "Zlib"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c735d2c226ba2c3bbb273dc035f7d8d9b3e7aa209198a1fa4db81fa3bd65122d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ca94517ee24158641169349e1289389c632dbe8f55fe397eb54704cbd966309"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9a48e0877e59ed375a4372a237fced65eff22269511616a34a02e31f00fabfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "e110cef52315db96a890215546ad3c20a47660b422f546c3333906cbeb4d4688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "175cca470c1bbe7ba1184e8e31882b4714d56ef5c124d631e916cfe8e0c61fda"
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
