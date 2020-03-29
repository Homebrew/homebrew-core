class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"
  url "https://github.com/HaxeFoundation/haxe.git",
      :tag      => "4.0.5",
      :revision => "67feacebc59d5cd9dce232058f12cb933622d619"
  head "https://github.com/HaxeFoundation/haxe.git", :branch => "development"

  bottle do
    cellar :any
    sha256 "e08d077a5ef5fb969ab8054ce75b60c1f73a5405a655c49671a211390b1bcaef" => :catalina
    sha256 "c204cefc408d68628d25b11c66331b8fc4f8b37573029480fc6ebc781991ce97" => :mojave
    sha256 "b90a4c12a07d00919081941b000bf98fcb8e560cd226beadb9123f67f6734049" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "neko"
  depends_on "pcre"

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize

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
  end
end
