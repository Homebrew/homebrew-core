class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://www.actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/refs/tags/1.0.1.tar.gz"
  sha256 "635bdd6e3b70886f1d9aa75c48e5bdb4084afae1f159bbfe5ea91f99b0460f6b"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f89384b764f867a22939a255260073cf37f0915824c1ec8c35efaeaaa15bb343"
    sha256 cellar: :any,                 arm64_sonoma:   "1e12a584df05f1cec7122920ced89d6bb99c55878a673da31bb66ed8c741b4e0"
    sha256 cellar: :any,                 arm64_ventura:  "c0790aeb9aef8cdd4379c4b06112871709ddf81b103068d92247f506bfa602fc"
    sha256 cellar: :any,                 arm64_monterey: "61a7b91ff6b083dbaa10e24be3cdfeb693d3e2c6e81c95a66804b5d6d9fc08c0"
    sha256 cellar: :any,                 sonoma:         "4d6531af952489110db600767de32e33bd70c0e65ce6ce9214fbe07f6365194f"
    sha256 cellar: :any,                 ventura:        "ee77d8ccc34bdb1b0050a094936ef9d2395abd9e42a55a3d170c573547ccc21b"
    sha256 cellar: :any,                 monterey:       "3d5ce3f385d9e01f38bf6621b1c0d3a7fb8177880c86b25d551142adae5c669c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f5dc9a456f8b1e63432bc16068cb1d33f0b88b2b2224223033c3018ba13ee4c"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  fails_with gcc: "5"

  def install
    tools = pkgshare/"tools"
    rpaths = [rpath, rpath(source: tools)]
    args = ["-DCAF_ENABLE_TESTING=OFF", "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}"]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <caf/all.hpp>
      using namespace caf;
      void caf_main(actor_system& system) {
        scoped_actor self{system};
        self->spawn([] {
          std::cout << "test" << std::endl;
        });
      }
      CAF_MAIN()
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lcaf_core", "-o", "test"
    system "./test"
  end
end
