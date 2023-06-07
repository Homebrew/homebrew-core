class G3log < Formula
  desc "Asynchronous, 'crash safe', logger that is easy to use"
  homepage "https://github.com/KjellKod/g3log"
  url "https://github.com/KjellKod/g3log/archive/2.3.tar.gz"
  sha256 "a27dc3ff0d962cc6e0b4e60890b4904e664b0df16393d27e14c878d7de09b505"
  license "Unlicense"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "481356063707027c8828318bfb9fd8d899ac1dc70e08a8d93d4346d5e8470a5d"
    sha256 cellar: :any,                 arm64_monterey: "ed9d36cbea6b0901495480e5a651a1fb5993cb6a76a711db0a242c1ff6b4345c"
    sha256 cellar: :any,                 arm64_big_sur:  "f536658de8315f431fa77fd6127951ca420dab5d199b93eb0bbc5cf9fdb7914c"
    sha256 cellar: :any,                 ventura:        "521f94740ba0ad93b5a3ef701651d481b9f6f2892cc0cb15529e1790dc008fd2"
    sha256 cellar: :any,                 monterey:       "b24e6270f4485efcd456edc7b1d7d22827881bfecc04c55c291d164910e55352"
    sha256 cellar: :any,                 big_sur:        "9ec2adbd30a14edcce9089f2668b8aee7d118eeebf84a42462758197f07dd926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4eaf7bd46646807c7ffff39ecdb391c342b76eaf9abf4f1b6f79c376510682e"
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
