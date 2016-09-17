class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://kripken.github.io/emscripten-site/"

  stable do
    url "https://github.com/kripken/emscripten/archive/1.36.5.tar.gz"
    sha256 "df18a63f540dd4b3ae58fcb7df91c5e19ec8563e07f16231ca5a8fd737348ee6"

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
    sha256 "0108e47d941db90f25bb836454d6b9bb8aee3493c59bb8f469c634149214a87b" => :sierra
    sha256 "cf1f89ef7693c1dd48e1460693269673cb3bbd9098c3228d9b7198a90d7cff8e" => :el_capitan
    sha256 "ca6952b6e028bc13134ed22e091616a95f3deeb3d09ddd8046bf08e5079dc0af" => :yosemite
    sha256 "ec769916fd5bb5696558fae42131c413f1d9fd6f97aa7fafd5cf34c893e102ab" => :mavericks
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
