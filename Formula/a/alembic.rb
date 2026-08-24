class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://www.alembic.io/"
  url "https://github.com/alembic/alembic/archive/refs/tags/1.8.12.tar.gz"
  sha256 "b6d916c40446e8c502c84273092ab3d98f3f7f6094f8a2b8203d23e2f1d2a4a0"
  license "BSD-3-Clause"
  head "https://github.com/alembic/alembic.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f05ae0d574d293c26b7f1d89c629caa455bc08bd0ab0370afb05fd18090b0efd"
    sha256 cellar: :any, arm64_sequoia: "475655b088a913e34b1febc61cc910ccc272bc226350e386d9d6647ab5bb4671"
    sha256 cellar: :any, arm64_sonoma:  "7600bde69829c734a2e00769a6991c5d8b5d07c545dc850f9e729b81bc264c7c"
    sha256 cellar: :any, sonoma:        "4020585258e85ebfdfa504d0dda096267a905cde59542c66563d3784dda11161"
    sha256 cellar: :any, arm64_linux:   "337be169d245808a04ecb62213a65c69bff77d30028288bbad9a7ae73b410ce5"
    sha256 cellar: :any, x86_64_linux:  "a5ad262b2967ec1aae15475918d316d6e88825f69f8e579499ca6d2b6083e180"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "imath"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[
      -DUSE_PRMAN=OFF
      -DUSE_ARNOLD=OFF
      -DUSE_MAYA=OFF
      -DUSE_PYALEMBIC=OFF
      -DUSE_HDF5=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "prman/Tests/testdata/cube.abc"
  end

  test do
    assert_match "root", shell_output("#{bin}/abcls #{pkgshare}/cube.abc")
  end
end
