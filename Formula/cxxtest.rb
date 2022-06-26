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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "290c7e2e1fe99e75a0f7b45d2808d971db1e39fb915acb11ec2d75ef15b18b0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "290c7e2e1fe99e75a0f7b45d2808d971db1e39fb915acb11ec2d75ef15b18b0c"
    sha256 cellar: :any_skip_relocation, monterey:       "e1bcaf3c8fbddf83977c8cbbde084f64d3915a22bbf023cb044423b7215c26ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1bcaf3c8fbddf83977c8cbbde084f64d3915a22bbf023cb044423b7215c26ee"
    sha256 cellar: :any_skip_relocation, catalina:       "e1bcaf3c8fbddf83977c8cbbde084f64d3915a22bbf023cb044423b7215c26ee"
    sha256 cellar: :any_skip_relocation, mojave:         "e1bcaf3c8fbddf83977c8cbbde084f64d3915a22bbf023cb044423b7215c26ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b808acbab8d4cc6aa173baafc1e35786e8253cc5a4f16e5bf8a35853aeed490"
  end

  depends_on "python@3.10"

  def install
    venv = virtualenv_create(libexec, Formula["python@3.10"].opt_bin/"python3")
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
