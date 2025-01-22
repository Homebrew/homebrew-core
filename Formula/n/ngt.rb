class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/refs/tags/v2.3.9.tar.gz"
  sha256 "2b0dabe1216ba063068834bed144bd1e077c79a5f8d8e05f53d0df2818d762cd"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3871b5a2e7c0940c550d7ac012abf761f2074655e98818627652d304d30807bd"
    sha256 cellar: :any,                 arm64_sonoma:  "00bd4d4d3dd8ac7990ac9945c8cbed68cc54575c619823019ea932c3b3acf3fc"
    sha256 cellar: :any,                 arm64_ventura: "ee39efbe71136e7d5e1f3b07d9f49df8537de6ff9926a7772f99b1957c99502f"
    sha256 cellar: :any,                 sonoma:        "8f1f411dd3a0bad5497eb22e972afb7b44e96e504de0b6e68ab32c3811a8f262"
    sha256 cellar: :any,                 ventura:       "59f12bb722907b9f93c3747e0d1fe1a7320abb12ab16e8e3468e753e1edb3ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "007182611b0f9d456095f8b88151dafdad06f9763f0a684b97db20d25466ab1f"
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
