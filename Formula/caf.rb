class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.16.0.tar.gz"
  sha256 "36e37971c399892302b738de18cbf3dd9049956228ede91cb09131eb5a18aa7f"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    cellar :any
    sha256 "781d27935c9feb66f7d4271df0cdcfb6d53515cfdc1402e6706d5c59fd05a372" => :mojave
    sha256 "ee5d7eaaef8344e97a60c5081b0d557ca248628541863bca84489d3ecd10e3ac" => :high_sierra
    sha256 "9091136ee2f067176a1dab4a060f24695d8944f20750d3ffab5374adb65dce68" => :sierra
    sha256 "423d9c03f8c45ebf29abe6fcee1daa86e74e266ba935aab40ed0cd6f99b3662d" => :el_capitan
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
