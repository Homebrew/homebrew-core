class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "4568624a4035b3317333c6fb78c35000f5cb9b3c66d0eb19bf52a6c49089190b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "19aec684cb184820acafcc8452bf27f5cadcf3f071f294e5244ff68d1f149f8c"
    sha256 cellar: :any,                 arm64_sequoia: "3e62869315a462fa0b78f1c2a90f1c5694bdf64a7523d3cf32dc2650e3cb924b"
    sha256 cellar: :any,                 arm64_sonoma:  "68d4e6f0a550c893b66ea7c1d144ed3832b50bbc7a1dd8a8759907ee2bbd0ff6"
    sha256 cellar: :any,                 sonoma:        "a6204a962ea74fd350766d563f2294e097781cc7d384ad397f26e4dee43a109e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bed923a50ada5d3f1dc0ea35ccf41b9399d72d9ae69ac7a41043fe376b1b2a51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "033fc5b1e6d4e571e95c21159f27f73c9d2f5457c5ec14d2670298dc9c92a698"
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
