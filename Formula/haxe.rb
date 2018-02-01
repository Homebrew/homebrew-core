class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"
  url "https://github.com/HaxeFoundation/haxe.git",
      :tag => "3.4.5",
      :revision => "666f17e8163d6ad30399b5f91ecadef77d07a105"

  bottle do
    cellar :any
    sha256 "baa0a054502fb1151d7dad57626cce36c5c6601db9f980639b61ea7810674908" => :high_sierra
    sha256 "bb9d6e20fb0c1ca9cc27633f5bc6c29e5187b37be89226cb59f038fa5dacd7b1" => :sierra
    sha256 "5dfaab0cfa7585478456bc8c4aeabc7d7e1cfae34aac3260399cfcc9df2a8fd8" => :el_capitan
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
    ENV["OCAMLPARAM"] = "safe-string=0,_" # OCaml 4.06.0 compat

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

  def caveats; <<~EOS
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
