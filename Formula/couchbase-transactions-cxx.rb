class CouchbaseTransactionsCxx < Formula
  desc "C++ transactions for Couchbase"
  homepage "https://docs.couchbase.com/cxx-txns/current/distributed-acid-transactions-from-the-sdk.html"
  url "https://packages.couchbase.com/clients/transactions-cxx/couchbase-transactions-1.0.0-source.tar.gz"
  sha256 "9c6b814f65834d3c194eecfdc6d9c3d133479297241e29eb223714769dfb86d3"
  license "Apache-2.0"
  head "https://github.com/couchbase/couchbase-transactions-cxx.git"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    # create simple app that tries to use client
    (testpath/"test.cpp").write <<~EOS
      #include <couchbase/client/cluster.hxx>
      #include <iostream>
      int main() {
        try {
          couchbase::cluster c("couchbase://1.1.1.1", "user", "pass");
          return 0;
        } catch (const std::exception& e) {
          std::cout << e.what() << std::endl;
          return 1;
        }
      }
    EOS
    system ENV.cc, "test.cpp", "--std=c++11", "-L#{lib}", "-lc++", "-ltransactions_cxx", "-o", "test"
    assert_match "LCB_ERR_TIMEOUT", shell_output("./test 2>&1", 1).strip
  end
end
