class Mixmod < Formula
  desc "Model-based supervised, unsupervised and semi-supervised classification"
  homepage "https://www.mixmod.org"
  url "https://github.com/mixmod/mixmod/archive/refs/tags/v2.1.12.tar.gz"
  sha256 "dd6c0d1fef7f2aa80e0c77680baa0718aa6326302bfd11b7e5dd99a378e5b277"
  license "GPL-3.0-only"

  head "https://github.com/mixmod/mixmod.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "eigen"

  def install
    args = %w[
      -DMIXMOD_BUILD_EXAMPLES=OFF
      -DMIXMOD_BUILD_IOSTREAM=OFF
      -DMIXMOD_BUILD_CLI=OFF
      -DCMAKE_UNITY_BUILD=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <mixmod.h>
      #include <cassert>

      int main() {
        // 20 samples, 2D, two well-separated clusters (10 each)
        int64_t nbSample = 20;
        int64_t pbDimension = 2;
        double **matrix = new double *[nbSample];
        for (int i = 0; i < nbSample; i++)
          matrix[i] = new double[pbDimension];
        for (int i = 0; i < 10; i++) {
          matrix[i][0] = 1.0 + i * 0.1;
          matrix[i][1] = 1.0 + i * 0.1;
        }
        for (int i = 0; i < 10; i++) {
          matrix[10 + i][0] = 8.0 + i * 0.1;
          matrix[10 + i][1] = 8.0 + i * 0.1;
        }

        auto *gData = new XEM::GaussianData(nbSample, pbDimension, matrix);
        auto *dataDesc = new XEM::DataDescription(gData);
        std::vector<int64_t> nbCluster = {2};
        auto *cInput = new XEM::ClusteringInput(nbCluster, *dataDesc);
        cInput->removeModelType(0);
        cInput->addModel(XEM::Gaussian_pk_L_I);
        cInput->getStrategy()->setNbTry(1);
        cInput->finalize();

        XEM::ClusteringMain cMain(cInput);
        cMain.run();
        XEM::ClusteringOutput *cOutput = cMain.getOutput();
        assert(cOutput->atLeastOneEstimationNoError());

        for (int i = 0; i < nbSample; i++)
          delete[] matrix[i];
        delete[] matrix;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{lib}", "-o", "test", "-lmixmod"
    system "./test"
  end
end
