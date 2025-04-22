class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "https://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.1.tar.gz"
  sha256 "c672a6379142ac2e872741e7662f17eccd8230bffc680564d2843d87480f1600"
  license "AGPL-3.0-only"
  revision 10

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4e30428a201c092dd95925dbf2cbcf0462c161fc9605de3208a6947435ca8f96"
    sha256 cellar: :any,                 arm64_sonoma:  "1daaaad0626d64ab84527ee4c3010e7d0182c0bb9105927b2a5ff67d450c508f"
    sha256 cellar: :any,                 arm64_ventura: "e7eb98da6f2e974de97e0b42212a36b873698aa46e615d52de003f736b0de0cc"
    sha256 cellar: :any,                 sonoma:        "18159dc9e41798f544bedf23ea60bf6f28dbd51504f2b518bc9862778765d0e3"
    sha256 cellar: :any,                 ventura:       "70f59ec40dbf77652da963e4c91102ca8df50fb53c25155d48f1420b7eae9233"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7d7377eedefefda284293356c01655d29e03e193b3e7f51a74f244d7a9ab01c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09ee37dbdbd8a8d47ad0c439b2b1067f96a5e7f683d78a0d29642f54ded934a8"
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
