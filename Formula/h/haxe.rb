class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"
  license all_of: ["GPL-2.0-or-later", "MIT"]
  head "https://github.com/HaxeFoundation/haxe.git", branch: "development"

  stable do
    # TODO: Remove `ctypes==0.21.1` pin when build fails from pointer mismatch (i.e. `luv >= 0.5.13`)
    # Ref: https://github.com/HaxeFoundation/haxe/commit/e646e6f182c920694968ba7a28ad01ddfee4519a
    # Ref: https://github.com/HaxeFoundation/haxe/commit/0866067940256afc9227a75f96baee6ec64ee373
    url "https://github.com/HaxeFoundation/haxe.git",
        tag:      "4.3.6",
        revision: "760c0dd9972abadceba4e72edb1db13b2a4fb315"

    # Backport support for mbedtls 3.x
    patch do
      url "https://github.com/HaxeFoundation/haxe/commit/c3258892c3c829ddd9faddcc0167108e62c84390.patch?full_index=1"
      sha256 "d92fa85053ed4303f147e784e528380f6a0f6f08d35b5d93fbdfbf072ca7ed3e"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f46b8c3720cefeda7d771f46a73873a68e1db5e76d45102c3107644222416053"
    sha256 cellar: :any,                 arm64_sonoma:   "d0b13478d395cf9ea455a25b7b07f6536b4bac3b041ad48790e85fb105b45fbb"
    sha256 cellar: :any,                 arm64_ventura:  "4a33e2aa4d5749040521f96cba3d3d3aa713e97db701063e3566d129e8251f75"
    sha256 cellar: :any,                 arm64_monterey: "026ce9fe643c092f45b85d6fb99842261583f5d1e4ecb83f43bc7ebb94d0341f"
    sha256 cellar: :any,                 sonoma:         "9376bf9c2c01df7a8ee36e1e474e909ef8e9e784d3eccd21760760868be65510"
    sha256 cellar: :any,                 ventura:        "c331d84365e3caf89e27f9b833c0b832a4b703c56b74d1e8c8895e810a9adca2"
    sha256 cellar: :any,                 monterey:       "8edf54dd46a8a8a786abb80d233d7ec0cad854e0a8484a32bde012030e929aec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37602a38987f6d010d03170855f54f85fc5ce193809234f6c5a7de9fb7486f8e"
  end

  depends_on "cmake" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"
  depends_on "neko"
  depends_on "pcre2"
  depends_on "zlib" # due to `mysql-client`

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
      system "opam", "exec", "--", "opam", "pin", "add", "ctypes", "0.21.1"
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
    ENV["HAXE_STD_PATH"] = HOMEBREW_PREFIX/"lib/haxe/std"

    system bin/"haxe", "-v", "Std"
    system bin/"haxelib", "version"

    (testpath/"HelloWorld.hx").write <<~EOS
      import js.html.Console;

      class HelloWorld {
          static function main() Console.log("Hello world!");
      }
    EOS
    system bin/"haxe", "-js", "out.js", "-main", "HelloWorld"

    cmd = if OS.mac?
      "osascript -so -lJavaScript out.js 2>&1"
    else
      "node out.js"
    end
    assert_equal "Hello world!", shell_output(cmd).strip
  end
end
