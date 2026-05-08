class Ginkgo < Formula
  desc "High-performance numerical linear algebra software package"
  homepage "https://ginkgo-project.github.io/"
  url "https://github.com/ginkgo-project/ginkgo/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "8052c3d5994e1c996ebabe50a169deb565965da4f1c6c02e814ff0c7146c0378"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3b9ecb1cb5b3da010d732863538fc51806e08cb58d043ed695f60143ee03f710"
    sha256 cellar: :any,                 arm64_sequoia: "604c528e0522106a0a448c0db771ba1bfe73234fa59b16ec615c90437e3b165a"
    sha256 cellar: :any,                 arm64_sonoma:  "0148bd93e11a249dcefccbfe80cb0d7e6d9d7093d44cc3d83898550cb063264a"
    sha256 cellar: :any,                 sonoma:        "16542b84e2db6a5f693f21114636f03b06f94f95487a7c5cc98b690a53c3b873"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4bb3792b1a5a486c82752d2d0eb820e5115592819c2792ef5011befffb40ebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3178e09f20b6b7c20f9e3e9ec004ec3b6a67e59b94e1a8f77990804026ca316"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "yaml-cpp" => :build
  depends_on "pkgconf" => :test
  depends_on "libomp"
  depends_on "metis"
  depends_on "open-mpi"

  def install
    # Avoid superenv shim reference
    inreplace "cmake/GinkgoConfig.cmake.in", "@CMAKE_CXX_COMPILER@", DevelopmentTools.locate(ENV.cxx)

    args = %w[
      -DGINKGO_BUILD_TESTS=OFF
      -DGINKGO_BUILD_BENCHMARKS=OFF
      -DGINKGO_MIXED_PRECISION=ON
      -DGINKGO_WITH_CCACHE=OFF
      -DGINKGO_BUILD_EXAMPLES=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    flags = shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --libs ginkgo").chomp.split

    (testpath/"version.cpp").write <<~CPP
      #include <iostream>
      #include <ginkgo/ginkgo.hpp>

      int main()
      {
        std::cout << gko::version_info::get() << std::endl;
        return 0;
      }
    CPP

    system Formula["open-mpi"].opt_bin/"mpic++", "version.cpp", "-std=c++17", *flags,
           "-Wl,-rpath,#{lib}", "-o", "version"

    assert_match version.to_s, shell_output("./version")

    (testpath/"test.cpp").write <<~'CPP'
      #include <ginkgo/ginkgo.hpp>
      #include <iostream>

      using Dense = gko::matrix::Dense<double>;

      void run(std::shared_ptr<gko::Executor> exec, const char* name)
      {
          auto A = Dense::create(exec, {2,2});
          auto x = Dense::create(exec, {2,1});
          auto y = Dense::create(exec, {2,1});

          A->at(0,0)=1; A->at(0,1)=2;
          A->at(1,0)=3; A->at(1,1)=4;
          x->at(0,0)=5; x->at(1,0)=6;

          A->apply(x.get(), y.get());

          std::cout << name << ": "
                    << y->at(0,0) << ", " << y->at(1,0) << "\n";
      }

      int main()
      {
          run(gko::ReferenceExecutor::create(), "REF");
          run(gko::OmpExecutor::create(), "OMP");
      }

    CPP
    system Formula["open-mpi"].opt_bin/"mpic++", "test.cpp", "-std=c++17", *flags,
           "-Wl,-rpath,#{lib}", "-o", "test"

    assert_equal "REF: 17, 39\nOMP: 17, 39\n", shell_output("./test")
  end
end
