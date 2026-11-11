class Libint < Formula
  desc "Library for computing electron repulsion integrals efficiently"
  homepage "https://github.com/evaleev/libint"
  url "https://github.com/evaleev/libint/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "0697b5861a3539e44c04b7a23634b935782e2dd50da76be49034119b83dd1c6d"
  # The generator is GPLv3 but it doesn't impact the license of packaged library
  license "LGPL-3.0-only"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "141b82e9f2106d4c4b2797121c832faf9a54521ebfe0faeaa8999540c7d095dd"
    sha256 cellar: :any, arm64_tahoe:       "f23cfd8b177ebc167e9c7aa3002ea05d1192d1da3eea7bcfc8b00dd3edd9ebb2"
    sha256 cellar: :any, arm64_sequoia:     "2c8c6bf72fee3ccfff9deafea234d594c2aea865638d88b109ef3450587ad025"
    sha256 cellar: :any, arm64_linux:       "1ab1d1572077d6335584c0fe3286755f956f08425c24901be456c2eade6dcbd5"
    sha256 cellar: :any, x86_64_linux:      "4bb17b738e047930fd5841ef09d55b0e0fe4616c75e50fdcf41421168f425760"
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
