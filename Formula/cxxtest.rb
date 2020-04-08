class Cxxtest < Formula
  include Language::Python::Virtualenv

  desc "C++ unit testing framework similar to JUnit, CppUnit and xUnit"
  homepage "https://cxxtest.com/"
  url "https://github.com/CxxTest/cxxtest/releases/download/4.4/cxxtest-4.4.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/c/cxxtest/cxxtest_4.4.orig.tar.gz"
  sha256 "1c154fef91c65dbf1cd4519af7ade70a61d85a923b6e0c0b007dc7f4895cf7d8"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "35c64fe6d91097fa9aabfc63a145e6e9e6f27411e589b69f0da77895045dc128" => :catalina
    sha256 "0c97b74f6bc2cee5e0683fcec6bd07da544b5f3e9cd25b9631b6291b86490392" => :mojave
    sha256 "4ef0fbb78839714da6108883475dce9536df2e59dd9dc7bf42677a86d00f4356" => :high_sierra
    sha256 "4ef0fbb78839714da6108883475dce9536df2e59dd9dc7bf42677a86d00f4356" => :sierra
  end

  depends_on "python@3.8"

  def install
    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")
    venv.pip_install_and_link buildpath/"python"

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
