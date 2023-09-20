class Foldseek < Formula
  desc "Search your protein structures in seconds"
  homepage "https://github.com/steineggerlab/foldseek"
  url "https://github.com/steineggerlab/foldseek/archive/8-ef4e960.tar.gz"
  version "8-ef4e960"
  sha256 "c74d02c4924d20275cc567783b56fff10e76ed67f3d642f53c283f67c4180a1e"
  license "GPL-3.0-or-later"
  head "https://github.com/steineggerlab/foldseek.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  resource "homebrew-testdata" do
    url "https://raw.githubusercontent.com/steineggerlab/foldseek/master/example/d1asha_"
    sha256 "b4ec14f5decc94b5363b3414db4d25e3e09039c7a6fbb585041730dcf3cc1fd8"
  end

  def install
    args = []
    if OS.mac?
      libomp = Formula["libomp"]
      args << "-DOpenMP_C_FLAGS=-Xpreprocessor -fopenmp -I#{libomp.opt_include}"
      args << "-DOpenMP_C_LIB_NAMES=omp"
      args << "-DOpenMP_CXX_FLAGS=-Xpreprocessor -fopenmp -I#{libomp.opt_include}"
      args << "-DOpenMP_CXX_LIB_NAMES=omp"
      args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.a"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "example"
  end

  test do
    resource("homebrew-testdata").stage testpath/"example"
    system bin/"foldseek", "easy-search", "example/d1asha_", "example", "aln", "tmpFolder"
    assert_equal "d1asha_\td1asha_\t1.000\t147\t0\t0\t1\t147\t1\t147\t1.011E-22\t1061\n", File.read("aln")
  end
end
