class Ginkgo < Formula
  desc "High-performance numerical linear algebra software package"
  homepage "https://ginkgo-project.github.io/"
  url "https://github.com/ginkgo-project/ginkgo/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "8052c3d5994e1c996ebabe50a169deb565965da4f1c6c02e814ff0c7146c0378"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "3ff463015e01cd53930559ccf943e7a37ff7a943575c46049c58ef28bfdf0904"
    sha256 cellar: :any, arm64_sequoia: "1c0ca68f48b47019a9f735a4233b0143fa698c360e789e608932630809465a97"
    sha256 cellar: :any, arm64_sonoma:  "76aeaabaaf2a48be3c2af53781be43aba8355399365df77ae482aabf1e3ce37a"
    sha256 cellar: :any, sonoma:        "7506667c5a4635d27f87e0751c4b16d604008d968a4cf00d6751c3d3338b999d"
    sha256 cellar: :any, arm64_linux:   "bf8024742f555ed57bac19002b1d020d408667f4636732c47f7f593c8766de7f"
    sha256 cellar: :any, x86_64_linux:  "f0ffea61795eb9e84e415a04f1ae91c608c80fe02fa8f8b2d4f31f607ce90a85"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "yaml-cpp" => :build
  depends_on "pkgconf" => :test
  depends_on "metis"
  depends_on "open-mpi"

  on_macos do
    depends_on "libomp"
  end

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
    flags = shell_output("#{formula_opt_bin("pkgconf")}/pkgconf --libs ginkgo").chomp.split

    (testpath/"version.cpp").write <<~CPP
      #include <iostream>
      #include <ginkgo/ginkgo.hpp>

      int main()
      {
        std::cout << gko::version_info::get() << std::endl;
        return 0;
      }
    CPP

    system formula_opt_bin("open-mpi")/"mpic++", "version.cpp", "-std=c++17", *flags,
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
    system formula_opt_bin("open-mpi")/"mpic++", "test.cpp", "-std=c++17", *flags,
           "-Wl,-rpath,#{lib}", "-o", "test"

    assert_equal "REF: 17, 39\nOMP: 17, 39\n", shell_output("./test")
  end
end
