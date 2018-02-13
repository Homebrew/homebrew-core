class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"
  url "https://github.com/HaxeFoundation/haxe.git",
      :tag => "3.4.6",
      :revision => "5b9de19d4841db7a4f746d83fdde3385eabddbc2"

  bottle do
    cellar :any
    sha256 "bd7d3a23054d3bfece87eb76de06c8ff53b0fac72d8343f7d8857571ba676951" => :high_sierra
    sha256 "f97d069c5d12ed98c1dd313545d3ecb53c2882efeff9a59d42a7cee07db7c1ee" => :sierra
    sha256 "ff4d4186eee5fc5a53c3578d43a266f171631b148c50bf525d4c9b01c2b8a9fb" => :el_capitan
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
