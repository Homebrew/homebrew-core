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
    sha256 "2fe73bcec8be89daf46ad449cced7ea3d5584d1eb8138343359fc0898e3ec826" => :big_sur
    sha256 "838265b9b44453641e3cbc39dbbb8903666ba3413ef8c7dc68af69f9759f4351" => :catalina
    sha256 "91e091b03e482a8bae5248a435a8e827c79923aaee9f98f99d33254e176560d2" => :mojave
    sha256 "bb10a673525d7145196f523190401c2aa42345b5035ed2bcf261081e3653638f" => :high_sierra
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
