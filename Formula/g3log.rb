class G3log < Formula
  desc "Asynchronous, 'crash safe', logger that is easy to use"
  homepage "https://github.com/KjellKod/g3log"
  url "https://github.com/KjellKod/g3log/archive/2.1.tar.gz"
  sha256 "13c9d8cc0387792301f264c4f623618fc4dea9814d9b5844931ffbfd9aafb1fe"
  license "Unlicense"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9ce7da10cc769d71f54eada1899be07111f115bd31dfa5b54c2c7cab4c40f79d"
    sha256 cellar: :any,                 arm64_monterey: "99997b6ac31ba2e254baa6b045dc0852c80960ec164955541c2e397d46fe376c"
    sha256 cellar: :any,                 arm64_big_sur:  "f7986791faae29689a5c14f0610f0ed28df3cc9fa777b6b8af1a93d5c839d687"
    sha256 cellar: :any,                 monterey:       "1a6a132534a972a432226947aab60285475b0ade28754518a96852add9f3eba4"
    sha256 cellar: :any,                 big_sur:        "1944ed238a728e517ad30758607f11e955252f9eead61e777b82c8f8f1f317b2"
    sha256 cellar: :any,                 catalina:       "eb81f87d497f5c9fc69bcafa7563aafd48ea9a76f880ee18a56e7bf51aa355a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b9436845f91a4a005eeab1aac299917fcbb77d949cb2d616135bb8caad85916"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS.gsub(/TESTDIR/, testpath)
      #include <g3log/g3log.hpp>
      #include <g3log/logworker.hpp>
      int main()
      {
        using namespace g3;
        auto worker = LogWorker::createLogWorker();
        worker->addDefaultLogger("test", "TESTDIR");
        g3::initializeLogging(worker.get());
        LOG(DEBUG) << "Hello World";
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lg3log", "-o", "test"
    system "./test"
    Dir.glob(testpath/"test.g3log.*.log").any?
  end
end
