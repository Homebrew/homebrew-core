class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://kripken.github.io/emscripten-site/"

  stable do
    url "https://github.com/kripken/emscripten/archive/1.36.1.tar.gz"
    sha256 "e0d098e78b8e0a11b3ac1719ff46b03edd32d41122184380596b572c41fc5f1e"

    resource "fastcomp" do
      url "https://github.com/kripken/emscripten-fastcomp/archive/1.36.1.tar.gz"
      sha256 "050134995da9d011fe128b61335f62424e3acbc769b78992d767733cfc9ff0d5"
    end

    resource "fastcomp-clang" do
      url "https://github.com/kripken/emscripten-fastcomp-clang/archive/1.36.1.tar.gz"
      sha256 "645496a61f725b5023b44970078d642b675a8469e0cd6a1e757f90a8d11724db"
    end
  end

  bottle do
    sha256 "27cce062785327422afcf54243f27b1f0257f1146c85cb5fa460995aad9464f0" => :el_capitan
    sha256 "59f97e1ea052e3c5bdbe0b8cfd045ac0a894a0f43563ff199e6c94bc70eeb93c" => :yosemite
    sha256 "856d76a56cbebfd555149c169750b57ede59777682ca7bce0607ac3f5e914f2f" => :mavericks
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
