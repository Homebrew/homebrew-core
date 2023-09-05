class Ibex < Formula
  desc "C++ library for constraint processing over real numbers"
  homepage "https://web.archive.org/web/20190826220512/www.ibex-lib.org/"
  url "https://github.com/ibex-team/ibex-lib/archive/ibex-2.8.9.tar.gz"
  sha256 "fee448b3fa3929a50d36231ff2f14e5480a0b82506594861536e3905801a6571"
  license "LGPL-3.0-only"
  head "https://github.com/ibex-team/ibex-lib.git", branch: "master"

  livecheck do
    url :stable
    regex(/^ibex[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura:      "eea592d2c1c13bde0a000ca8705cabce4e11aeabb76a30dc8baf09931b9a22dd"
    sha256 cellar: :any_skip_relocation, monterey:     "5fe0810e9f6ef9b72c7d1e9ceba7b6b9c37410dd93f9801ac37e9738ec245005"
    sha256 cellar: :any_skip_relocation, big_sur:      "dbe9f4d68e4a406bd4926d6c821887e32af2d323f1d7ecd9a729ee0957c3e120"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1b64c5e784e7585d8a70179625a1a10a9b1c6926bd224c3d165abaed3db66c78"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => [:build, :test]

  uses_from_macos "zlib"

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args.reject { |s| s["CMAKE_INSTALL_LIBDIR"] }
      system "make", "SHARED=true"
      system "make", "install"
    end

    pkgshare.install %w[examples benchs/solver]
    (pkgshare/"examples/symb01.txt").write <<~EOS
      function f(x)
        return ((2*x,-x);(-x,3*x));
      end
    EOS
  end

  test do
    ENV.cxx11

    cp_r (pkgshare/"examples").children, testpath

    (1..8).each do |n|
      system "make", "lab#{n}"
      system "./lab#{n}"
    end

    (1..3).each do |n|
      system "make", "-C", "slam", "slam#{n}"
      system "./slam/slam#{n}"
    end
  end
end
