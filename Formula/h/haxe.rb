class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"
  url "https://github.com/HaxeFoundation/haxe.git",
      tag:      "4.3.4",
      revision: "dc1a43dc52f98b9c480f68264885c6155e570f3e"
  license all_of: ["GPL-2.0-or-later", "MIT"]
  head "https://github.com/HaxeFoundation/haxe.git", branch: "development"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f9140f08adc58e7030fa8ea1075bafdd1bd05c09bb7e57603d02bd72b51114bb"
    sha256 cellar: :any,                 arm64_ventura:  "04e1bb1eea4b08df50a8a0330b712d1849caabc5a1966551e1e408ff15a9277f"
    sha256 cellar: :any,                 arm64_monterey: "2303db002a051595108fbea9f9d9979f0520f7e4921f72304182fc141c96d897"
    sha256 cellar: :any,                 sonoma:         "10918b5c843f9791844373b3ed88fb5e3559481ac5ddda32d29bf76ed5a37bf5"
    sha256 cellar: :any,                 ventura:        "bfcff7fe36be9c1b45fadeff1079761e0ba1970ad4691862931045c393d02d47"
    sha256 cellar: :any,                 monterey:       "e3ad219e0c53d2e31ac4dfb994b060f2c48bf17d109109f0ada836adc9436bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1363cbbb3683279eeb69c09dffcd69853e08486810423dc640be0079d206bfc2"
  end

  depends_on "cmake" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"
  depends_on "neko"
  depends_on "pcre2"

  uses_from_macos "m4" => :build
  uses_from_macos "perl" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  on_linux do
    depends_on "node" => :test
  end

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
      system "opam", "exec", "--", "opam", "pin", "add", "haxe", buildpath, "--no-action"
      system "opam", "exec", "--", "opam", "install", "haxe", "--deps-only", "--working-dir", "--no-depexts"
      system "opam", "exec", "--", "make"
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

    cmd = if OS.mac?
      "osascript -so -lJavaScript out.js 2>&1"
    else
      "node out.js"
    end
    assert_equal "Hello world!", shell_output(cmd).strip
  end
end
