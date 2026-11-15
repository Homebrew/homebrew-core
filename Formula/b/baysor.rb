class Baysor < Formula
  desc "Bayesian segmentation of imaging-based spatial transcriptomics data"
  homepage "https://github.com/kharchenkolab/Baysor"
  url "https://github.com/kharchenkolab/Baysor/archive/refs/tags/cpp-0.9.0.tar.gz"
  sha256 "d495e85207a5961bfb4e937f8833973b4230d10b54f883df25e778d9414b2d5c"
  license "MIT"
  revision 1
  head "https://github.com/kharchenkolab/Baysor.git", branch: "cpp"

  livecheck do
    url :stable
    regex(/^cpp[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8f006d8aa75998b1ba52dfea091863677777ad7186f5bac7fd7e5a9a0910eb6e"
    sha256 cellar: :any, arm64_tahoe:       "b7ddf651a44519c6eb0987c9df48852a529bc72b3f551dede8d724531fb66234"
    sha256 cellar: :any, arm64_sequoia:     "09df3493765d46b1f73f84e02fafaedb0e65fdfbdfa2c98208caf91135e37040"
    sha256 cellar: :any, arm64_linux:       "f740545e7a63200cab7e205b2abb8b35175ccb9822fd6f448ee2eab59692497f"
    sha256 cellar: :any, x86_64_linux:      "1e1ef48028875d03530942d3da4da979c0820e9322c7a187a01658cf609a91cf"
  end

  depends_on "cgal" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "nlohmann-json" => :build
  depends_on "apache-arrow"
  depends_on "fmt"
  depends_on "gmp"
  depends_on "hdf5"
  depends_on "libtiff"
  depends_on "mpfr"
  depends_on "spdlog"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Header-only dependencies that upstream fetches with `FetchContent` at
  # configure time, at the tags pinned in CMakeLists.txt.
  resource "aarand" do
    url "https://github.com/LTLA/aarand/archive/refs/tags/v1.0.2.tar.gz"
    sha256 "106309082292356d5ae546c24bbd2295416aaff378755ec1f1645207fce10323"

    livecheck do
      url "https://raw.githubusercontent.com/kharchenkolab/Baysor/refs/tags/cpp-#{LATEST_VERSION}/CMakeLists.txt"
      regex(/FetchContent_Declare\(aarand\s+GIT_REPOSITORY\s+\S+\s+GIT_TAG\s+v?(\d+(?:\.\d+)+)/i)
    end
  end

  resource "kmeans" do
    url "https://github.com/LTLA/CppKmeans/archive/refs/tags/v3.1.1.tar.gz"
    sha256 "3895fe98e16c7c20a2f0a4d07706bdb3f4e8546e55c1e83e912ad8e1c8e24067"

    livecheck do
      url "https://raw.githubusercontent.com/kharchenkolab/Baysor/refs/tags/cpp-#{LATEST_VERSION}/CMakeLists.txt"
      regex(/FetchContent_Declare\(kmeans\s+GIT_REPOSITORY\s+\S+\s+GIT_TAG\s+v?(\d+(?:\.\d+)+)/i)
    end
  end

  resource "subpar" do
    url "https://github.com/LTLA/subpar/archive/refs/tags/v0.3.1.tar.gz"
    sha256 "dc9c450be5176a05ce697c6feadbdd84d1fe530e414d1e0d2837e89174ecc1de"

    livecheck do
      url "https://raw.githubusercontent.com/kharchenkolab/Baysor/refs/tags/cpp-#{LATEST_VERSION}/CMakeLists.txt"
      regex(/FetchContent_Declare\(subpar\s+GIT_REPOSITORY\s+\S+\s+GIT_TAG\s+v?(\d+(?:\.\d+)+)/i)
    end
  end

  resource "knncolle" do
    url "https://github.com/knncolle/knncolle/archive/refs/tags/v2.3.0.tar.gz"
    sha256 "25a87e56d037fec491b55a39807f58c6466766200d34b6e3f54c5c2b771dddca"

    livecheck do
      url "https://raw.githubusercontent.com/kharchenkolab/Baysor/refs/tags/cpp-#{LATEST_VERSION}/CMakeLists.txt"
      regex(/FetchContent_Declare\(knncolle\s+GIT_REPOSITORY\s+\S+\s+GIT_TAG\s+v?(\d+(?:\.\d+)+)/i)
    end
  end

  resource "irlba" do
    url "https://github.com/LTLA/CppIrlba/archive/refs/tags/v2.0.2.tar.gz"
    sha256 "c5daed5bdaf5991f324e1081f7c180c2fecc0da5bf0f60af057547d28fa56127"

    livecheck do
      url "https://raw.githubusercontent.com/kharchenkolab/Baysor/refs/tags/cpp-#{LATEST_VERSION}/CMakeLists.txt"
      regex(/FetchContent_Declare\(irlba\s+GIT_REPOSITORY\s+\S+\s+GIT_TAG\s+v?(\d+(?:\.\d+)+)/i)
    end
  end

  resource "umappp" do
    url "https://github.com/LTLA/umappp/archive/refs/tags/v2.0.1.tar.gz"
    sha256 "e846b6bac2bb4e5020d76e739b792a492ed63fc27cc45bd27be238053675b5f6"

    livecheck do
      url "https://raw.githubusercontent.com/kharchenkolab/Baysor/refs/tags/cpp-#{LATEST_VERSION}/CMakeLists.txt"
      regex(/FetchContent_Declare\(umappp\s+GIT_REPOSITORY\s+\S+\s+GIT_TAG\s+v?(\d+(?:\.\d+)+)/i)
    end
  end

  deny_network_access!

  def install
    fetchcontent_args = resources.map do |r|
      r.stage(buildpath/"third_party"/r.name)
      "-DFETCHCONTENT_SOURCE_DIR_#{r.name.upcase}=#{buildpath}/third_party/#{r.name}"
    end

    system "cmake", "-S", ".", "-B", "build", "-DFETCHCONTENT_FULLY_DISCONNECTED=ON",
                    *fetchcontent_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Two well-separated clumps of molecules drawn from three genes.
    genes = %w[geneA geneB geneC]
    rows = [0, 100].flat_map do |offset|
      Array.new(24) { |i| "#{offset + ((i % 4) * 2)},#{(i / 4) * 2},#{genes[i % 3]}" }
    end
    (testpath/"molecules.csv").write "x,y,gene\n#{rows.join("\n")}\n"

    system bin/"baysor", "run", "-m", "5", "-s", "3", "-o", testpath/"out", testpath/"molecules.csv"

    segmentation = (testpath/"out/segmentation.csv").read
    assert_match "cell,gene,x,y", segmentation.lines.first
    assert_equal rows.count + 1, segmentation.lines.count

    # Each clump must be segmented into one cell.
    cell_stats = (testpath/"out/segmentation_cell_stats.csv").read.lines
    assert_equal 2, cell_stats.count - 1
  end
end
