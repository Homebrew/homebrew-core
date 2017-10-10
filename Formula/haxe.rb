class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"
  url "https://github.com/HaxeFoundation/haxe.git",
      :tag => "3.4.4",
      :revision => "4f09586f6691e8a9645844b62036c8c974a00d15"

  bottle do
    cellar :any
    sha256 "f8744f5b9b6bd78beac33ed9f42f087edf195023361997127a87f5e86aa4a6ab" => :high_sierra
    sha256 "165161d050573f4a7a083ead8686424b1cb1fdf0ec13910dbe6418c5d9b8a9fc" => :sierra
    sha256 "5c1b387666ef82b9709ead193f21291b3793a93b70da58c0026d578ff4a0310e" => :el_capitan
  end

  head do
    url "https://github.com/HaxeFoundation/haxe.git", :branch => "development"
    depends_on "opam" => :build
  end

  depends_on "ocaml" => :build
  depends_on "camlp4" => :build
  depends_on "cmake" => :build
  depends_on "neko"
  depends_on "pcre"

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize

    if build.head?
      ENV["OPAMROOT"] = buildpath/"opamroot"
      ENV["OPAMYES"] = "1"
      system "opam", "init", "--no-setup"
      system "opam", "config", "exec", "--", "opam", "install", "ocamlfind",
             "sedlex", "xml-light", "extlib", "rope", "ptmap>2.0.1"
      system "opam", "config", "exec", "--", "make", "ADD_REVISION=1"
    else
      system "make", "OCAMLOPT=ocamlopt.opt"
    end

    # Rebuild haxelib as a valid binary
    cd "extra/haxelib_src" do
      system "cmake", "."
      system "make"
    end
    rm "haxelib"
    cp "extra/haxelib_src/haxelib", "haxelib"

    bin.mkpath
    system "make", "install", "INSTALL_BIN_DIR=#{bin}",
           "INSTALL_LIB_DIR=#{lib}/haxe", "INSTALL_STD_DIR=#{lib}/haxe/std"

    # Replace the absolute symlink by a relative one,
    # such that binary package created by homebrew will work in non-/usr/local locations.
    rm bin/"haxe"
    bin.install_symlink lib/"haxe/haxe"
  end

  def caveats; <<-EOS.undent
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
