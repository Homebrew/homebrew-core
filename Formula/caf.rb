class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.16.2.tar.gz"
  sha256 "4c1e74dc2b45d14504c6a676dcd6fe168f6b5a5c605cbdb0588e55e58412d29c"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    cellar :any
    sha256 "366a8b02c11a1b85982f997a444f3746fe357621ba4f30318cd0ea80a10a13f5" => :mojave
    sha256 "dfb5544b6ed9e4dd1adea288059f09f41556322ca4367b061c1d8b1130bf0cf4" => :high_sierra
    sha256 "bb76ebe67503d8d456811f0b2fea1c28cad7a8226e8a860fbaac2bec5455c2cd" => :sierra
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    system "./configure", "--prefix=#{prefix}", "--no-examples",
                          "--build-static", "--no-opencl"
    system "make"
    system "make", "test"
    system "make", "install"
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
        self->await_all_other_actors_done();
      }
      CAF_MAIN()
    EOS
    ENV.cxx11
    system *(ENV.cxx.split + %W[test.cpp -L#{lib} -lcaf_core -o test])
    system "./test"
  end
end
