class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.18.0.tar.gz"
  sha256 "df765fa78861e67d44e2587c0ac0c1c662d8c93fe5ffc8757f552fc7ac15941f"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0779640072ac88745f00f5946958a815f0deeb19dba46509181fd2ee944d4aa8" => :big_sur
    sha256 "0343f31ed5a9532c8b495b27956203994827ce1f42e8c5b0702161f42dbd8c59" => :arm64_big_sur
    sha256 "131af3b3422867d6cb4c9e46d773e7b102e2dd9209be5d844cbbe99a1a7c6883" => :catalina
    sha256 "20b60e3ee9f2953ac5453aeb1c5d724b1141f5b90be8b2b2d611f9f0938ff913" => :mojave
    sha256 "be54ecedb3968591490e165d7260b0b8c19745e44d125fde2a5cd209fa71fc16" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-shared-libs",
                          "--disable-testing"
    system "make", "--directory=build", "install"
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
