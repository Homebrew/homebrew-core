class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://www.alembic.io/"
  url "https://github.com/alembic/alembic/archive/refs/tags/1.8.11.tar.gz"
  sha256 "ab299bb4b1894a6675c73fa29940522b54c81a91b1d691ca3470d86b7345ffce"
  license "BSD-3-Clause"
  head "https://github.com/alembic/alembic.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e998ad08677ded32645d1c6760c18a6fe28d9498cb0c7d92b95f52afe0d18cfd"
    sha256 cellar: :any,                 arm64_sequoia: "c6063967c5f8228950ee6fc37028a299995fadfe16df49dbf7822e9408a14110"
    sha256 cellar: :any,                 arm64_sonoma:  "29c5928e08940c9d21732fd5bc5748a9d717775136a82fef23861c48982f802c"
    sha256 cellar: :any,                 sonoma:        "d97e5d2e338e7b80b6cd9abcee30dcda081be9cafa5bf6ea08c67a3cd61ada64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cff7051b91258b01135979d371daab9202bbac592c8729cfcb28d402fb941526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30bb652271cc38b693c199281ae88c89944ad738212ae347d52f633ae20a2cd5"
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
