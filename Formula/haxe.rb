class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"
  url "https://github.com/HaxeFoundation/haxe.git",
      :tag => "3.4.2",
      :revision => "890f8c70cf23ce6f9fe0fdd0ee514a9699433ca7"
  head "https://github.com/HaxeFoundation/haxe.git", :branch => "development"

  bottle do
    cellar :any
    sha256 "698bb9fe8d6fe5d546949469d082f6877658ad74feff0c7149d22675ce01109e" => :sierra
    sha256 "2b72ad031bc21749162ae4cb2e8cb8488519b1b9998b6fe051a3b4de25cbda8a" => :el_capitan
    sha256 "07da6182e4e2482c941a0b7e5d3ec0bda852ab6702c0067153c02e0c3a3a1925" => :yosemite
  end

  depends_on "ocaml" => :build
  depends_on "camlp4" => :build
  depends_on "cmake" => :build
  depends_on "neko"
  depends_on "pcre"

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize
    args = ["OCAMLOPT=ocamlopt.opt"]
    args << "ADD_REVISION=1" if build.head?
    system "make", *args

    # Rebuild haxelib as a valid binary
    cd "extra/haxelib_src" do
      system "cmake", "."
      system "make"
    end
    rm "haxelib"
    cp "extra/haxelib_src/haxelib", "haxelib"

    bin.mkpath
    system "make", "install", "INSTALL_BIN_DIR=#{bin}", "INSTALL_LIB_DIR=#{lib}/haxe"

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
