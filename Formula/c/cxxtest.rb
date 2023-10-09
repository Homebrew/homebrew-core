class Cxxtest < Formula
  include Language::Python::Virtualenv

  desc "C++ unit testing framework similar to JUnit, CppUnit and xUnit"
  homepage "https://github.com/CxxTest/cxxtest"
  url "https://github.com/CxxTest/cxxtest/releases/download/4.4/cxxtest-4.4.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/c/cxxtest/cxxtest_4.4.orig.tar.gz"
  sha256 "1c154fef91c65dbf1cd4519af7ade70a61d85a923b6e0c0b007dc7f4895cf7d8"
  license "LGPL-3.0"
  revision 3

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3a91bb0a415bc900e0c4bb96f06c66bd52ec0a764408fc58baf7cc0a9f4fc41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1453f41f97d5c9599df362b6479598ff7d1e6c1a34b0f1032f07928af6140588"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9926336e8e6414bba551d5bdba28fb9482988263e133de3a145e3cc398b6ecfc"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc363090d5c0745f7836bc6c7f6ae9889588ea0af15286df0e375ae832a002a7"
    sha256 cellar: :any_skip_relocation, ventura:        "f591a787799ac5f5824a3ef9e94226f893ca72d206d8adcb31950141c635e8ab"
    sha256 cellar: :any_skip_relocation, monterey:       "9536137dafbdf87265874438cd883d5f6654ce14b7d761911b02ac3e1e8b36ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42c3d117a42f8ef77c5ec762a392cbf36f068ed2416ee6812d978dc4c9426742"
  end

  depends_on "python@3.12"

  def install
    venv = virtualenv_create(libexec, "python3.12")
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
