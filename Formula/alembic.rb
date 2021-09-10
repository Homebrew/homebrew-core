class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://github.com/alembic/alembic/archive/1.8.2.tar.gz"
  sha256 "3f1c466ee1600578689b32b1f2587066d3259704ec7ed1fcf80c324d01274f48"
  license "BSD-3-Clause"
  head "https://github.com/alembic/alembic.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "46c5f8566ef35e3e8e9142fc17b7d9427158a71fc5d9c6438cfa6c54a3bfff27"
    sha256 cellar: :any,                 big_sur:       "2eb888ba085f317e78cf98b90d1e550ed9184e9c4ffe9ccf335b2103daa4d746"
    sha256 cellar: :any,                 catalina:      "0b67c411fc9eb77667cba798784169274cd82ce4e2d85be274b161870b3c05aa"
    sha256 cellar: :any,                 mojave:        "54f37a4687cce1e482a238ad5c7302f580bb630434dd0279f311d1423d02db4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4dd5488dd07a9200aa47f0d3c4ffedb6e9b76cb382a2f5bcb3e841074b92d63"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "imath"
  depends_on "szip"

  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args + %w[
      -DUSE_PRMAN=OFF
      -DUSE_ARNOLD=OFF
      -DUSE_MAYA=OFF
      -DUSE_PYALEMBIC=OFF
      -DUSE_HDF5=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "prman/Tests/testdata/cube.abc"
  end

  test do
    assert_match "root", shell_output("#{bin}/abcls #{pkgshare}/cube.abc")
  end
end
