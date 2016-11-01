class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://kripken.github.io/emscripten-site/"

  stable do
    url "https://github.com/kripken/emscripten/archive/1.36.13.tar.gz"
    sha256 "5e5370384a80775eaed63f38dcbc11f38620239f21c3fd6ba3725b5c982a2736"

    resource "fastcomp" do
      url "https://github.com/kripken/emscripten-fastcomp/archive/1.36.5.tar.gz"
      sha256 "322501d14eb90b5590d463ef2ae1b358c07c590440d7bd21b60ea88885bc2fa0"
    end

    resource "fastcomp-clang" do
      url "https://github.com/kripken/emscripten-fastcomp-clang/archive/1.36.5.tar.gz"
      sha256 "b6a35fe26efaaaaea5d3d1139e61d5754760f03bed0a4af87236767d1a56b00d"
    end
  end

  bottle do
    sha256 "3585fd9a6d92e461613b03cb42758ade8e811ad603b290e6743983500aaf9f30" => :sierra
    sha256 "74dd27fe744335b4be1cc3d9f670c87a285bc0b1b08fb26f343d532214328b07" => :el_capitan
    sha256 "e8b1b317bf338d70984487460fb74fb5c7216f136314b3c642eb04bea7e2ebdb" => :yosemite
  end

  head do
    url "https://github.com/kripken/emscripten.git", :branch => "incoming"

    resource "fastcomp" do
      url "https://github.com/kripken/emscripten-fastcomp.git", :branch => "incoming"
    end

    resource "fastcomp-clang" do
      url "https://github.com/kripken/emscripten-fastcomp-clang.git", :branch => "incoming"
    end
  end

  needs :cxx11

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "node"
  depends_on "closure-compiler" => :optional
  depends_on "yuicompressor"

  def install
    ENV.cxx11
    # OSX doesn't provide a "python2" binary so use "python" instead.
    python2_shebangs = `grep --recursive --files-with-matches ^#!/usr/bin/.*python2$ #{buildpath}`
    python2_shebang_files = python2_shebangs.lines.sort.uniq
    python2_shebang_files.map! { |f| Pathname(f.chomp) }
    python2_shebang_files.reject! &:symlink?
    inreplace python2_shebang_files, %r{^(#!/usr/bin/.*python)2$}, "\\1"

    # All files from the repository are required as emscripten is a collection
    # of scripts which need to be installed in the same layout as in the Git
    # repository.
    libexec.install Dir["*"]

    (buildpath/"fastcomp").install resource("fastcomp")
    (buildpath/"fastcomp/tools/clang").install resource("fastcomp-clang")

    args = [
      "--prefix=#{libexec}/llvm",
      "--enable-optimized",
      "--enable-targets=host,js",
      "--disable-assertions",
      "--disable-bindings",
    ]

    mkdir "fastcomp/build" do
      system "../configure", *args
      system "make"
      system "make", "install"
    end

    %w[em++ em-config emar emcc emcmake emconfigure emlink.py emmake
       emranlib emrun emscons].each do |emscript|
      bin.install_symlink libexec/emscript
    end
  end

  def caveats; <<-EOS.undent
    Manually set LLVM_ROOT to
      #{opt_libexec}/llvm/bin
    in ~/.emscripten after running `emcc` for the first time.
    EOS
  end

  test do
    system "#{libexec}/llvm/bin/llvm-config", "--version"
  end
end
