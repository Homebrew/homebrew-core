class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://kripken.github.io/emscripten-site/"

  stable do
    url "https://github.com/kripken/emscripten/archive/1.38.20.tar.gz"
    sha256 "9f486c3b9516a82e2cbc6968d07746ae4bad013e4358ac6f2a5c1bc829ca6700"

    resource "fastcomp" do
      url "https://github.com/kripken/emscripten-fastcomp/archive/1.38.20.tar.gz"
      sha256 "23c3944271e3cd15c9ee8998ae8690f8f07b340ecde9ba222e3af039228d2376"
    end

    resource "fastcomp-clang" do
      url "https://github.com/kripken/emscripten-fastcomp-clang/archive/1.38.20.tar.gz"
      sha256 "16ff2ec08987d98d1763433f402b158311445d81368984e79aaf9d3d99eb2d68"
    end
  end

  bottle do
    cellar :any
    sha256 "e8efef6cfcf6754297ec329aeeeb95be85816d4f329c8c253a5b1acccc46b6cf" => :mojave
    sha256 "827204b9dfa80edf8a6af506e959450148c5c801b6b3e54489f2de6ac7e444ef" => :high_sierra
    sha256 "ec8a4f636fa6b6dc3bb45c49e9b9af258cb3bedfe8f55f89a2f570baa4a707c0" => :sierra
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

  depends_on "cmake" => :build
  depends_on "node"
  depends_on "python@2"
  depends_on "yuicompressor"
  depends_on "closure-compiler" => :optional

  needs :cxx11

  def install
    ENV.cxx11
    # rewrite hardcoded paths from system python to homebrew python
    python2_shebangs = `grep --recursive --files-with-matches ^#!/usr/bin/python #{buildpath}`
    python2_shebang_files = python2_shebangs.lines.sort.uniq
    python2_shebang_files.map! { |f| Pathname(f.chomp) }
    python2_shebang_files.reject! &:symlink?
    inreplace python2_shebang_files, %r{^#!/usr/bin/python2?$}, "#!#{Formula["python@2"].opt_bin}/python2"

    # All files from the repository are required as emscripten is a collection
    # of scripts which need to be installed in the same layout as in the Git
    # repository.
    libexec.install Dir["*"]

    (buildpath/"fastcomp").install resource("fastcomp")
    (buildpath/"fastcomp/tools/clang").install resource("fastcomp-clang")

    cmake_args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] }
    cmake_args = [
      "-DCMAKE_BUILD_TYPE=Release",
      "-DCMAKE_INSTALL_PREFIX=#{libexec}/llvm",
      "-DLLVM_TARGETS_TO_BUILD='X86;JSBackend'",
      "-DLLVM_INCLUDE_EXAMPLES=OFF",
      "-DLLVM_INCLUDE_TESTS=OFF",
      "-DCLANG_INCLUDE_TESTS=OFF",
      "-DOCAMLFIND=/usr/bin/false",
      "-DGO_EXECUTABLE=/usr/bin/false",
    ]

    mkdir "fastcomp/build" do
      system "cmake", "..", *cmake_args
      system "make"
      system "make", "install"
    end

    %w[em++ em-config emar emcc emcmake emconfigure emlink.py emmake
       emranlib emrun emscons].each do |emscript|
      bin.install_symlink libexec/emscript
    end
  end

  def caveats; <<~EOS
    Manually set LLVM_ROOT to
      #{opt_libexec}/llvm/bin
    and comment out BINARYEN_ROOT
    in ~/.emscripten after running `emcc` for the first time.
  EOS
  end

  test do
    system bin/"emcc"
    assert_predicate testpath/".emscripten", :exist?, "Failed to create sample config"
  end
end
