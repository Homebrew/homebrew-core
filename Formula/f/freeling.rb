class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "https://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.1.tar.gz"
  sha256 "c672a6379142ac2e872741e7662f17eccd8230bffc680564d2843d87480f1600"
  license "AGPL-3.0-only"
  revision 13

  # Last release on 2022-07-15, bundles a copy of `dynet` which doesn't work
  # with latest Eigen and requires patching to build with latest ICU
  deprecate! date: "2026-02-02", because: :unmaintained
  disable! date: "2026-08-13", because: :unmaintained

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "dynet"
  depends_on "icu4c@78"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "foma", because: "freeling ships its own copy of foma"
  conflicts_with "hunspell", because: "both install 'analyze' binary"
  conflicts_with "crfsuite", because: "both install `crfsuite` binaries"

  def install
    # Unbundle `dynet` and its dependency `eigen`
    rm_r(["src/eigen3", "src/libdynet"])
    (buildpath/"src/eigen3").mkpath
    (buildpath/"src/libdynet/CMakeLists.txt").write ""

    # icu4c 75+ needs C++17
    inreplace "CMakeLists.txt", "set(CMAKE_CXX_STANDARD 11)", "set(CMAKE_CXX_STANDARD 17)"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install "#{bin}/fl_initialize"
    inreplace "#{bin}/analyze",
      ". $(cd $(dirname $0) && echo $PWD)/fl_initialize",
      ". #{libexec}/fl_initialize"
  end

  test do
    expected = <<~EOS
      Hello hello NN 1
      world world NN 1
    EOS
    assert_equal expected, pipe_output("#{bin}/analyze -f #{pkgshare}/config/en.cfg", "Hello world").chomp
  end
end
