class Libint < Formula
  desc "Library for computing electron repulsion integrals efficiently"
  homepage "https://github.com/evaleev/libint"
  url "https://github.com/evaleev/libint/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "9651705c79f77418ef0230aafc0cf1b71b17c1c89e413ee0e5ee7818650ce978"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "021285dd3c9f6f83647c2561fb5d51eed76f7093483fe23fb8541cb463f81b85"
    sha256 cellar: :any,                 arm64_sequoia: "95ec5448bcc73ce713eeaf1fce1cc59ccb9bc21421cca17e33a53378cb3a14e2"
    sha256 cellar: :any,                 arm64_sonoma:  "d311e23cd5cdeb601aaa98f8fd1c023bf8edfd95b7073814c4a7e0725599f850"
    sha256 cellar: :any,                 sonoma:        "a90f91cd6b70acdcacf6c72eefeadf8a7973dd85f27af1ea3fcfd02b2a409f99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7c85675c38ecae95182d1f75922ba5a8f8cd729fe6ef441b232e7d9f0d959ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "924eb316cb90dd18ced1e1d52f2ddeefe8e6a13300d866450b966be540f72a7f"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "gmp" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "boost" => :no_linkage
  depends_on "eigen" => :no_linkage

  uses_from_macos "python" => :build

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_CXX_STANDARD=14
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
                    "-I#{Formula["eigen"].opt_include}/eigen3",
                    *shell_output("pkgconf --cflags --libs libint2").chomp.split
    system "./hartree-fock", pkgshare/"h2o.xyz"
  end
end
