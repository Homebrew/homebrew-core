class Libtommath < Formula
  desc "C library for number theoretic multiple-precision integers"
  homepage "https://www.libtom.net/LibTomMath/"
  url "https://github.com/libtom/libtommath/releases/download/v1.0.1/ltm-1.0.1.tar.xz"
  sha256 "47032fb39d698ce4cf9c9c462c198e6b08790ce8203ad1224086b9b978636c69"
  head "https://github.com/libtom/libtommath.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d408a93196ac8bff3df209e0d734a6c95540bbe16eb9ab2fc2fe2ac582e2e5a0" => :mojave
    sha256 "b1f415b9e856a624a378fc2bf6805772b3d609fc52d3112e7cf2b68be45e230d" => :high_sierra
    sha256 "e8b549106cfaebb72663904b2597ab444c67104ca1824f2a96f2c013efc3fe64" => :sierra
    sha256 "1b5e1b5d062dfb4945016516880ca227fe13b03cb214985d317f657f6a45a06e" => :el_capitan
    sha256 "7d042e9ccfd1ba6a86c97f570960116524601b0586274132d3d66c7bb6a550c2" => :yosemite
  end

  def install
    ENV["DESTDIR"] = prefix

    system "make"
    system "make", "test_standalone"
    include.install Dir["tommath*.h"]
    lib.install "libtommath.a"
    pkgshare.install "test"
  end

  test do
    system pkgshare/"test"
  end
end
