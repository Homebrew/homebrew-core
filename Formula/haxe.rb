class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"
  url "https://github.com/HaxeFoundation/haxe.git",
      tag:      "4.1.5",
      revision: "5e33a78aad9a6733f4aa3a4b99f7c14555523a36"
  head "https://github.com/HaxeFoundation/haxe.git", branch: "development"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "2dd8ce7d51cc9fc0f81a4bd3fd7cc768c17d1b82ca8258cd725505a2a93f47ce" => :big_sur
    sha256 "78bf7c08233e8c8d1b5adf3ced4281bcf946500ca3943900b7814383f6e41718" => :catalina
    sha256 "a14642ba794f4bf71a0db224452511da6c630f574f2f940e6ee509bfe514569b" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"
  depends_on "neko"
  depends_on "pcre"

  uses_from_macos "m4" => :build
  uses_from_macos "perl" => :build
  uses_from_macos "unzip" => :build

  resource "String::ShellQuote" do
    url "https://cpan.metacpan.org/authors/id/R/RO/ROSCH/String-ShellQuote-1.04.tar.gz"
    sha256 "e606365038ce20d646d255c805effdd32f86475f18d43ca75455b00e4d86dd35"
  end

  resource "IPC::System::Simple" do
    url "https://cpan.metacpan.org/authors/id/J/JK/JKEENAN/IPC-System-Simple-1.30.tar.gz"
    sha256 "22e6f5222b505ee513058fdca35ab7a1eab80539b98e5ca4a923a70a8ae9ba9e"
  end

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      ENV["ADD_REVISION"] = "1" if build.head?
      system "opam", "init", "--no-setup", "--disable-sandboxing"
      system "opam", "config", "exec", "--",
             "opam", "pin", "add", "haxe", buildpath, "--no-action"
      system "opam", "config", "exec", "--",
             "opam", "install", "haxe", "--deps-only"
      system "opam", "config", "exec", "--",
             "make"
    end

    # Rebuild haxelib as a valid binary
    cd "extra/haxelib_src" do
      system "cmake", ".", *std_cmake_args
      system "make"
    end
    rm "haxelib"
    cp "extra/haxelib_src/haxelib", "haxelib"

    bin.mkpath
    system "make", "install", "INSTALL_BIN_DIR=#{bin}",
           "INSTALL_LIB_DIR=#{lib}/haxe", "INSTALL_STD_DIR=#{lib}/haxe/std"
  end

  def caveats
    <<~EOS
      Add the following line to your .bashrc or equivalent:
        export HAXE_STD_PATH="#{HOMEBREW_PREFIX}/lib/haxe/std"
    EOS
  end

  test do
    ENV["HAXE_STD_PATH"] = "#{HOMEBREW_PREFIX}/lib/haxe/std"
    system "#{bin}/haxe", "-v", "Std"
    system "#{bin}/haxelib", "version"

    (testpath/"HelloWorld.hx").write <<~EOS
      import js.html.Console;

      class HelloWorld {
          static function main() Console.log("Hello world!");
      }
    EOS
    system "#{bin}/haxe", "-js", "out.js", "-main", "HelloWorld"
    _, stderr, = Open3.capture3("osascript -so -lJavaScript out.js")
    assert_match /^Hello world!$/, stderr
  end
end
