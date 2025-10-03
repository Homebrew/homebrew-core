class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "https://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.1.tar.gz"
  sha256 "c672a6379142ac2e872741e7662f17eccd8230bffc680564d2843d87480f1600"
  license "AGPL-3.0-only"
  revision 11

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "274f39196a43fd18262ffb687dff3e46a5b9735bd614e44d3d3ae0642a811944"
    sha256 cellar: :any,                 arm64_sequoia: "4d03e05512e15205712905c6fcce7f8c60eab88d1aa5d25416d0efa7a7c11e15"
    sha256 cellar: :any,                 arm64_sonoma:  "e42599bb112cad791a8b2da21fe4dbd84d0783b5fb9f21106c9bbf2a786c256f"
    sha256 cellar: :any,                 arm64_ventura: "9914627e7c0754f65831e135913ceac39a906076aea1f1ce89067efcc23a67f4"
    sha256 cellar: :any,                 sonoma:        "c07d45a1ba0dc3f160792207222ed4283298bbadbbe1701d5749b1c5eea1ff06"
    sha256 cellar: :any,                 ventura:       "707b36583e45938822b0d02cdc5d1485530c1c1692780e07bc2e8eb3fe6be2b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eef0f2dba68b9d9f25fad1aa0b795717424838b825291fce5427d386def0d427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4268db05446a7752caffc6e796dceacad945556c9220b930ea21b220a34473d4"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "dynet"
  depends_on "icu4c@77"

  uses_from_macos "zlib"

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
