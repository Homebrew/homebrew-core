class Pystring < Formula
  desc "Collection of C++ functions for the interface of Python's string class methods"
  homepage "https://github.com/imageworks/pystring"
  url "https://github.com/imageworks/pystring/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "020a603a757ba1e429f4b1ea6feb3afbe0fb34bcafa355032e1f1b8a0019d198"
  license "BSD-3-Clause"
  head "https://github.com/imageworks/pystring.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "33b316a29f203f8cec54fd08ba5b4309cc819720c9081e30ef0f6e818507da95"
    sha256 cellar: :any, arm64_sequoia: "afdabdf9a48a659bf0c51f89a9d54a2170528b0986baaacaf7340a746b314947"
    sha256 cellar: :any, arm64_sonoma:  "69d7a031c53081256eb1226352336ea9d2e3b69690f12d879c3d57a048874735"
    sha256 cellar: :any, sonoma:        "e8b5146d3905be7be8c4682a7a95ad19224a7b1c65f59e64f2e9c68cc6bd0cb1"
    sha256 cellar: :any, arm64_linux:   "60c5777af3e2c58d6977bae0d47ea5a6cdb99a9a60111f1da01b03d8ab656d90"
    sha256 cellar: :any, x86_64_linux:  "6b565ee430bec5d7f4d892ba85d8cac665c273c802b9c06f9f447bf4ab5cfdf8"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    include.install "pystring.h"
    pkgshare.install "test.cpp", "unittest.h"
  end

  test do
    system ENV.cxx, "-std=c++11", pkgshare/"test.cpp", "-I#{include}", "-I#{pkgshare}", "-L#{lib}",
                    "-lpystring", "-o", "test"
    system "./test"
  end
end
