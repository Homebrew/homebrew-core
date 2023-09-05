class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "d22e8e2e91e1967afda5cf27eaeaa4ab3d40694c7716b4d328d69a50e05d5115"
  license all_of: ["LGPL-3.0-only", "GPL-3.0-only"]
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "459944b69f6696883339cf10250a72ee3262adc73ee5d8cfd4eed224890d1681"
    sha256 cellar: :any,                 arm64_monterey: "e48ec9dcab6c0306b94ccfe3fc776446eea11d946fbf491378b8fe818d7000f1"
    sha256 cellar: :any,                 arm64_big_sur:  "ecd6a2a4d9e6845fb4e134145e68501e679dd1f574134ffd91d38559108acd14"
    sha256 cellar: :any,                 ventura:        "814bfffa3e31b7f9368250af37995636b0ce99dc3a911e12cb8db4523123f76c"
    sha256 cellar: :any,                 monterey:       "8c06f84df0799aaebec9c324359ea9acc2e41b4db206ae31aac52a4ef643c313"
    sha256 cellar: :any,                 big_sur:        "19a9dfeefbdee9159d2c16961cb67109ec3215e1eda91559a46265f5c060517f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "918bd6e7546a96a404ecc66941fefe09a5d7a055a1447bf0b1ddcb64c3e068a9"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "boost"
  depends_on "gmp"
  depends_on "openblas"
  depends_on "tbb"

  def install
    cmake_args = %w[
      -DBOOST=ON
      -DGMP=ON
      -DLUSOL=ON
      -DQUADMATH=ON
      -DTBB=ON
      -DBLA_VENDOR=OpenBLAS
    ]

    system "cmake", "-B", "papilo-build", "-S", ".", *cmake_args, *std_cmake_args
    system "cmake", "--build", "papilo-build"
    system "cmake", "--install", "papilo-build"

    pkgshare.install "test/instances/test.mps"
  end

  test do
    output = shell_output("#{bin}/papilo presolve -f #{pkgshare}/test.mps")
    assert_match "presolving finished after", output
  end
end
