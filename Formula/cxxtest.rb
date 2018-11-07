class Cxxtest < Formula
  desc "xUnit-style unit testing framework for C++"
  homepage "https://cxxtest.com/"
  url "https://github.com/CxxTest/cxxtest/releases/download/4.4/cxxtest-4.4.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/c/cxxtest/cxxtest_4.4.orig.tar.gz"
  sha256 "1c154fef91c65dbf1cd4519af7ade70a61d85a923b6e0c0b007dc7f4895cf7d8"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0c97b74f6bc2cee5e0683fcec6bd07da544b5f3e9cd25b9631b6291b86490392" => :mojave
    sha256 "4ef0fbb78839714da6108883475dce9536df2e59dd9dc7bf42677a86d00f4356" => :high_sierra
    sha256 "4ef0fbb78839714da6108883475dce9536df2e59dd9dc7bf42677a86d00f4356" => :sierra
  end

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", lib/"python#{xy}/site-packages"

    cd "./python" do
      system "python3", *Language::Python.setup_install_args(prefix)
    end

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    include.install "cxxtest"
    doc.install Dir["doc/*"]
  end

  test do
    testfile = testpath/"MyTestSuite1.h"
    testfile.write <<~EOS
      #include <cxxtest/TestSuite.h>

      class MyTestSuite1 : public CxxTest::TestSuite {
      public:
          void testAddition(void) {
              TS_ASSERT(1 + 1 > 1);
              TS_ASSERT_EQUALS(1 + 1, 2);
          }
      };
    EOS

    system bin/"cxxtestgen", "--error-printer", "-o", testpath/"runner.cpp", testfile
    system ENV.cxx, "-o", testpath/"runner", testpath/"runner.cpp"
    system testpath/"runner"
  end
end
