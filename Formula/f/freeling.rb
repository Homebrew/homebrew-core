class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "https://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.1.tar.gz"
  sha256 "c672a6379142ac2e872741e7662f17eccd8230bffc680564d2843d87480f1600"
  license "AGPL-3.0-only"
  revision 13

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "da96408a42b876a1aefc4337783ebb0203b5ccdbe487d363fe3594bbd5aed321"
    sha256 cellar: :any,                 arm64_sequoia: "cb2fffda68c5af4a65a43eecc84a8650097454d9c78c94dd37e96288e505eb9a"
    sha256 cellar: :any,                 arm64_sonoma:  "60c5ffef39d292344fb0dad6d11ed9fb0b9f39bb4508e919fe42175666588347"
    sha256 cellar: :any,                 sonoma:        "4171dbc6b31de0360a4278f503660de5376847db28cc4bf97af4b286a871c8fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3daf501eb541caf93c400beea8633264c5468f7a41b59294cb31cf36b489b853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bde9ff0e82cddc046515d15f8808c867dee2435e22f072a99d2e9bfdddd3d218"
  end

  # Last release on 2022-07-15, bundles a copy of `dynet` which doesn't work
  # with latest Eigen and requires patching to build with latest ICU
  deprecate! date: "2026-02-02", because: :unmaintained
  disable! date: "2027-02-02", because: :unmaintained

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
