class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.14.3.tar.gz"
  sha256 "e3a2c6085001bf9183d214f93aa1ed89ac10ce93c2327799ca8e5d8c10a8edf1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "319e1a5f01d84a1ab3b530970c6a243560667fc484fb63570aee8fcca0e28421"
    sha256 cellar: :any,                 arm64_big_sur:  "ace13556a5334a255eab6c632b5a2323847ceb112b27c7c0e712e26f3df20536"
    sha256 cellar: :any,                 monterey:       "2e16c8d92bbb5ba21a510c25498a02386afe6689ad2df30d26f213115f3f065f"
    sha256 cellar: :any,                 big_sur:        "4490d0e160f4a326679e62dc5e0459fce3c7f6f4c2f29131bbb36704ff892f11"
    sha256 cellar: :any,                 catalina:       "6b8d4bacacf99a24b722b50c790e58e6451169c92cefd10ada65a6c06fc19fef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ef908d4dc4d3dfc124cab68a31619469b97b3bbebfc14a14e5a88793c7c8523"
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make"
      system "make", "install"
    end
    pkgshare.install "data"
  end

  test do
    cp_r (pkgshare/"data"), testpath
    system "#{bin}/ngt", "-d", "128", "-o", "c", "create", "index", "data/sift-dataset-5k.tsv"
  end
end
