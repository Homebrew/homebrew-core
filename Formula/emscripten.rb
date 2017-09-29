class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://kripken.github.io/emscripten-site/"

  stable do
    url "https://github.com/kripken/emscripten/archive/1.37.18.tar.gz"
    sha256 "884639710a18f085a6257ffda33aa6df7ea358378a92e7f02499883b32f548cc"

    emscripten_tag = version.to_s
    resource "fastcomp" do
      url "https://github.com/kripken/emscripten-fastcomp/archive/#{emscripten_tag}.tar.gz"
      sha256 "8dc1c5e100942f80c61abbd1aa85178bd17d7c22d04ed16200552c8ccce97962"
    end

    resource "fastcomp-clang" do
      url "https://github.com/kripken/emscripten-fastcomp-clang/archive/#{emscripten_tag}.tar.gz"
      sha256 "594be8bfdfd121534b35645b1e05cd4028226c9304ee054a34f422cf89a816af"
    end

    # Fix for when /usr/bin/env python resolves to python 3.x.
    # Submitted upstream on 2017-08-27:
    # https://github.com/kripken/emscripten/pull/5534
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/8de3e51/emscripten/emscripten-resolve-symlinks.patch"
      sha256 "d34cec4c1a33e67465b94993ae836ded727cbe0bb9e2c31e73b4cd22d6995234"
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "4b943607343ed923775e18041e084c07191b087c61add7233be8df06ed24f665" => :sierra
    sha256 "c7ebea5722f9bbb0342455c29b015f0a5a05864652df156cc65abd960e795adf" => :el_capitan
    sha256 "991e6c66e68c32973515ef2623022cfa84a051d2d357d72c42e04d7894740397" => :yosemite
  end

  head do
    url "https://github.com/kripken/emscripten.git", :branch => "master"

    resource "fastcomp" do
      url "https://github.com/kripken/emscripten-fastcomp.git", :branch => "master"
    end

    resource "fastcomp-clang" do
      url "https://github.com/kripken/emscripten-fastcomp-clang.git", :branch => "master"
    end
  end

  needs :cxx11

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "cmake" => :build
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

  def caveats; <<-EOS.undent
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
