class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "98b547a7149fbfffe959b2a51789b0ab51474c03a819d1cb03771e562f256a64"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5b3e365c677182adc23181ac97ddafea6627e66a712f21f2826f54d9c40c969e"
    sha256 cellar: :any,                 arm64_sequoia: "47691f0ed74d1f3a24e3289d53a3445a8c4c4f9ee9d5903c4e188bcb99c892d6"
    sha256 cellar: :any,                 arm64_sonoma:  "7d870c0bdbcc53949dd88cc4b5871f86d245ab13e91ef6afc558612178865722"
    sha256 cellar: :any,                 sonoma:        "acd5dbbbfdca0e85e45cbba25cd5e24aa196c026a184312317772462b48cba66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d004177e9b90d09e2b259f93d1b0227ce877c2ffa1716b30276b018ead7fd18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "967aecaea32dd7705d29cb2addff1b7692c5e4151f1a19148335f3037fe77748"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DNGT_BFLOAT_DISABLED=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "data"
  end

  test do
    cp_r (pkgshare/"data"), testpath
    system bin/"ngt", "-d", "128", "-o", "c", "create", "index", "data/sift-dataset-5k.tsv"
  end
end
