class Ibex < Formula
  desc "C++ library for constraint processing over real numbers"
  homepage "https://web.archive.org/web/20190826220512/www.ibex-lib.org/"
  url "https://github.com/ibex-team/ibex-lib/archive/ibex-2.8.9.tar.gz"
  sha256 "fee448b3fa3929a50d36231ff2f14e5480a0b82506594861536e3905801a6571"
  license "LGPL-3.0-only"
  head "https://github.com/ibex-team/ibex-lib.git"

  livecheck do
    url :head
    regex(/^ibex[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6c0ab52bf081342e3467176f3f777ca5825df8fae28e10d70cdad41978728a8c" => :catalina
    sha256 "9ce827d5149844bcef31509aff4f4700865029ed6c21d941fc6d1301c1ab6a06" => :mojave
    sha256 "ae4bc25a0504f206517129a809afa42c26bba93f93573c4cba97cddd0726f63f" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => [:build, :test]

  uses_from_macos "zlib"

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
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
