class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "280d5472563cdb9f1e7e69f55a580522f7bbb2b2789aa14de56e80d707291421"
  license all_of: ["LGPL-3.0-only", "GPL-3.0-only"]
  revision 1
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5f432ab518a3259af803010a3324931d4799d6b81e9df8593acac580e7c38c68"
    sha256 cellar: :any,                 arm64_sonoma:  "27dd9f0a85e954377d3112d69efcec91b1ca03e2238fe4f3c3a224b49efb84d4"
    sha256 cellar: :any,                 arm64_ventura: "7a5dc4540ac1293c9d8f1d7055c48c8ba7fe9c09c67072283f8f04b9ad7689d5"
    sha256 cellar: :any,                 sonoma:        "97b1f943de9291cf78e8b0c051354ae8f58f4a454bcc0584cc7121169d9885a2"
    sha256 cellar: :any,                 ventura:       "f6c1f5f1cc49452cb9dd0b3e2beccda6d1bbd988d0ec2a477646adfe686bd7a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "855211dc6bfb5bba5bb510aac1e4d5bbcad7f3f7a5bfd24a67069bf0738fdeb5"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gcc"
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
