class Baysor < Formula
  desc "Bayesian segmentation of imaging-based spatial transcriptomics data"
  homepage "https://github.com/kharchenkolab/Baysor"
  url "https://github.com/kharchenkolab/Baysor/archive/refs/tags/cpp-0.8.3.tar.gz"
  sha256 "7ea3997388898cabd095df39faa8cb30551516a3c37eb010f99f29056aff0b9f"
  license "MIT"
  head "https://github.com/kharchenkolab/Baysor.git", branch: "cpp"

  livecheck do
    url :stable
    regex(/^cpp[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "nlohmann-json" => :build
  depends_on "apache-arrow"
  depends_on "cgal"
  depends_on "fmt"
  depends_on "gmp"
  depends_on "hdf5"
  depends_on "libtiff"
  depends_on "mpfr"
  depends_on "spdlog"

  on_macos do
    depends_on "libomp"
  end

  # Header-only dependencies that upstream fetches with `FetchContent` at
  # configure time, at the tags pinned in CMakeLists.txt.
  resource "aarand" do
    url "https://github.com/LTLA/aarand/archive/refs/tags/v1.0.2.tar.gz"
    sha256 "106309082292356d5ae546c24bbd2295416aaff378755ec1f1645207fce10323"
  end

  resource "kmeans" do
    url "https://github.com/LTLA/CppKmeans/archive/refs/tags/v3.1.1.tar.gz"
    sha256 "3895fe98e16c7c20a2f0a4d07706bdb3f4e8546e55c1e83e912ad8e1c8e24067"
  end

  resource "subpar" do
    url "https://github.com/LTLA/subpar/archive/refs/tags/v0.3.1.tar.gz"
    sha256 "dc9c450be5176a05ce697c6feadbdd84d1fe530e414d1e0d2837e89174ecc1de"
  end

  resource "knncolle" do
    url "https://github.com/knncolle/knncolle/archive/refs/tags/v2.3.0.tar.gz"
    sha256 "25a87e56d037fec491b55a39807f58c6466766200d34b6e3f54c5c2b771dddca"
  end

  resource "irlba" do
    url "https://github.com/LTLA/CppIrlba/archive/refs/tags/v2.0.2.tar.gz"
    sha256 "c5daed5bdaf5991f324e1081f7c180c2fecc0da5bf0f60af057547d28fa56127"
  end

  resource "umappp" do
    url "https://github.com/LTLA/umappp/archive/refs/tags/v2.0.1.tar.gz"
    sha256 "e846b6bac2bb4e5020d76e739b792a492ed63fc27cc45bd27be238053675b5f6"
  end

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
