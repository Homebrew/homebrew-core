class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  url "https://github.com/pachterlab/kallisto/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "68184e41706d77e409f05a598a87dacdf3cf227f18c028175e2bce8b284bdea4"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3b826ca4d994122b319591e6bca6a2bcdb6afa39b8d3e9e4adb3046dded637bc"
    sha256 cellar: :any,                 arm64_sequoia: "3af3db453b6c133763c14ff05f98e49a503f9bd8ea7250b7944cc24da74c74e3"
    sha256 cellar: :any,                 arm64_sonoma:  "f70f4260e9dee02e41a4d01c53cf8bf88ca6884e481d4db76f55bf694e5eb735"
    sha256 cellar: :any,                 sonoma:        "62334c7e3f262ad2d3a20054515148f8ff4d64a91940ff503860811075bb5a59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "708134380a902ba4dbf785cd2e456892fafc11f8e05ada86db37ff5dd14da632"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb55e7980c60d8c5fdf341a7a79f3a21978f27c09d51056b20dc1866694a6c54"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # PR ref: https://github.com/pachterlab/kallisto/pull/506
  # Fix error: no member named 'sz_link' in 'DataStorage<Unitig_data_t>'
  patch do
    url "https://github.com/pachterlab/kallisto/commit/a5caefb608611c48e102d63e91eafd3660d3e569.patch?full_index=1"
    sha256 "e29be49cc52a18f78b13b381f2d97cdf047ea45ba6b61b94caa54d46e195d0e2"
  end
  # Fix missing hdf5 libraries
  patch do
    url "https://github.com/pachterlab/kallisto/commit/e79245b1386d984849f2274fd2287a85682991bc.patch?full_index=1"
    sha256 "0a2e28de1bbe247842f5f6082a00ac60158ffe3d3264b639131d16b9c8c2e1a5"
  end

  def install
    # Fix to error: unsupported option '-mno-avx2'
    inreplace "ext/bifrost/CMakeLists.txt", "-mno-avx2", ""

    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    ENV.deparallelize

    # Workaround to build with CMake 4
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    system "cmake", "-S", ".", "-B", "build", "-DUSE_HDF5=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >seq0
      FQTWEEFSRAAEKLYLADPMKVRVVLKYRHVDGNLCIKVTDDLVCLVYRTDQAQDVKKIEKF
    EOS

    output = shell_output("#{bin}/kallisto index -i test.index test.fasta 2>&1")
    assert_match "has 1 contigs and contains 32 k-mers", output
  end
end
