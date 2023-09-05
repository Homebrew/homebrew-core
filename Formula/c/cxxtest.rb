class Cxxtest < Formula
  include Language::Python::Virtualenv

  desc "C++ unit testing framework similar to JUnit, CppUnit and xUnit"
  homepage "https://cxxtest.com/"
  url "https://github.com/CxxTest/cxxtest/releases/download/4.4/cxxtest-4.4.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/c/cxxtest/cxxtest_4.4.orig.tar.gz"
  sha256 "1c154fef91c65dbf1cd4519af7ade70a61d85a923b6e0c0b007dc7f4895cf7d8"
  license "LGPL-3.0"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1acc8d9a13d8955aece0bb80dc297469df4fb2f10948a1e9869ff26b8ec37fa4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1acc8d9a13d8955aece0bb80dc297469df4fb2f10948a1e9869ff26b8ec37fa4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1acc8d9a13d8955aece0bb80dc297469df4fb2f10948a1e9869ff26b8ec37fa4"
    sha256 cellar: :any_skip_relocation, ventura:        "5c6d1561562d7d6e8d2c18df851d8b961bda69b4c8a42094b174b92a55d52324"
    sha256 cellar: :any_skip_relocation, monterey:       "5c6d1561562d7d6e8d2c18df851d8b961bda69b4c8a42094b174b92a55d52324"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c6d1561562d7d6e8d2c18df851d8b961bda69b4c8a42094b174b92a55d52324"
    sha256 cellar: :any_skip_relocation, catalina:       "5c6d1561562d7d6e8d2c18df851d8b961bda69b4c8a42094b174b92a55d52324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cf39bf39e516f6a2649f9693b6c45e2cd73dd6eaf63ccae2cc6ea34f116e93e"
  end

  depends_on "python@3.11"

  def install
    venv = virtualenv_create(libexec, "python3.11")
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
