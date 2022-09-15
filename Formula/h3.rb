class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/v4.0.1.tar.gz"
  sha256 "01891901707c6430caaea7e645ff5ac6980cae166094a6f924ded197e5774a19"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5ccfa8701b32825395c48a357bd2e70a36667f2b4baa98764f76843315a23273"
    sha256 cellar: :any,                 arm64_big_sur:  "5caef45b04bc8bc3213e0188a81d162c6169683823f04203adc9242ed773d0dd"
    sha256 cellar: :any,                 monterey:       "f131ea0412bcaa6686152d9497ed329ffa5418f6130aa5239a49e8d2ff5e82c4"
    sha256 cellar: :any,                 big_sur:        "ccb72ef40580a82c89b254dab5d0f1ea08a256dfdd6af1b3fc8cfb940643ca00"
    sha256 cellar: :any,                 catalina:       "46948db333917ed24a8c558f48477cbfecabbe5dfcb058745008404a22571aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfc07c7796ea3ee96808a8cfdd3001e1b46a25a2cc913991faaca41baed2c702"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    result = pipe_output("#{bin}/latLngToCell -r 10 --lat 40.689167 --lng -74.044444")
    assert_equal "8a2a1072b59ffff", result.chomp
  end
end
