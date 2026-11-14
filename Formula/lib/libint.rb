class Libint < Formula
  desc "Library for computing electron repulsion integrals efficiently"
  homepage "https://github.com/evaleev/libint"
  url "https://github.com/evaleev/libint/archive/refs/tags/v2.14.1.tar.gz"
  sha256 "d40f15a1e3c271d5520ec06028f76152fa9ed796f7fc27fd36ee4f93b940605a"
  # The generator is GPLv3 but it doesn't impact the license of packaged library
  license "LGPL-3.0-only"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "eaa0f4507ea2ec6ff553c312ef71a06c8d90cbe86e81f6f541aaae275d9311dc"
    sha256 cellar: :any, arm64_tahoe:       "23c21254ea701d450b269710213fe19d9ff8cdcb42c9f5b50a00fff60e00d030"
    sha256 cellar: :any, arm64_sequoia:     "91d3c20a49eb0bbc4443915847833d9ba95a152ad3d9f5a343a69f6aee6a038e"
    sha256 cellar: :any, arm64_linux:       "09a8d105908457d6f8ea49cabdb6c40aa6b6058bbf13231fca11bedff242e58b"
    sha256 cellar: :any, x86_64_linux:      "821069df17d6ea3c16a8e18107dc7096b74c36269b9b7958cb96dc35c9c5c551"
  end

  depends_on "cmake" => :build
  depends_on "gmp" => :build
  depends_on "pkgconf" => :build

  depends_on "boost" => :no_linkage
  depends_on "eigen" => :no_linkage
  depends_on "gcc" # for libgfortran

  uses_from_macos "python" => :build

  deny_network_access!

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
                    "-I#{formula_opt_include("eigen")}/eigen3", "-L#{lib}", "-lint2"
    system "./hartree-fock", pkgshare/"h2o.xyz"
  end
end
