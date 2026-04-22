class Libint < Formula
  desc "Library for computing electron repulsion integrals efficiently"
  homepage "https://github.com/evaleev/libint"
  url "https://github.com/evaleev/libint/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "9651705c79f77418ef0230aafc0cf1b71b17c1c89e413ee0e5ee7818650ce978"
  # The generator is GPLv3 but it doesn't impact the license of packaged library
  license "LGPL-3.0-only"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4b03a7d26170b597d8420de0020de22fca8622a1a5990f6139b11df4727722df"
    sha256 cellar: :any,                 arm64_sequoia: "a46b2a128693e96482d182bd7ba1a28c146e5aaa591c264fca7bcdd0b8c7ae79"
    sha256 cellar: :any,                 arm64_sonoma:  "69d323511bf9d7556ed922c1b623a7777dc7bdebecd77fb4d85cae61af2e0e17"
    sha256 cellar: :any,                 sonoma:        "8f26efba8c16c3e353832d6b9a070cf68a005a853fe473feacad779aaf5f65a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "963b6d12f7047ea666a2b5f18f021bde6578bdcebc25f5007a49137b157d023e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34def8f50947bcdf2d36667e9bbb9bed785d9b52f62a7ebfef7020dd02f52b5b"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "gmp" => :build
  depends_on "pkgconf" => :build

  depends_on "boost" => :no_linkage
  depends_on "eigen" => :no_linkage

  uses_from_macos "python" => :build

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DLIBINT2_ENABLE_ERI=1
      -DLIBINT2_ENABLE_ERI2=1
      -DLIBINT2_ENABLE_ERI3=1
      -DLIBINT2_ENABLE_FORTRAN=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "export/tests/hartree-fock/hartree-fock.cc"
    pkgshare.install "export/tests/hartree-fock/h2o.xyz"
  end

  test do
    system ENV.cxx, "-std=c++14", pkgshare/"hartree-fock.cc", "-o", "hartree-fock",
                    "-I#{Formula["eigen"].opt_include}/eigen3", "-L#{lib}", "-lint2"
    system "./hartree-fock", pkgshare/"h2o.xyz"
  end
end
