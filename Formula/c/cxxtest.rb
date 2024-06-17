class Cxxtest < Formula
  include Language::Python::Virtualenv

  desc "C++ unit testing framework similar to JUnit, CppUnit and xUnit"
  homepage "https://github.com/CxxTest/cxxtest"
  url "https://github.com/CxxTest/cxxtest/releases/download/4.4/cxxtest-4.4.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/c/cxxtest/cxxtest_4.4.orig.tar.gz"
  sha256 "1c154fef91c65dbf1cd4519af7ade70a61d85a923b6e0c0b007dc7f4895cf7d8"
  license "LGPL-3.0-only"
  revision 3

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acdd395db8b77593f1d468bd9a47c10fa51b344bf50526df3fb965cde6f79ee6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74609617e8b9782eabdffe240ab7818a746ccd8eabe6ec4bce7d0cd98d240cc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b08f08b062b7627be2000866176fc1f00ff5c47130640ddf344a49ee827ee45"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b2acef8c5b8aba77b4192b6572558a00fa4548d818ce6ed2119730fa8dfe9c6"
    sha256 cellar: :any_skip_relocation, ventura:        "ed2ae59c74952d59677cc0411da3935dd8d1c2a415eb8cd60ea5d05a8d8fcad3"
    sha256 cellar: :any_skip_relocation, monterey:       "639a40eda611f0370f70d0bcc3a4daad6e4c5a081862137622e377c3664abdb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1613e42bf7a9153b9f8cefb7a00667d7ec4f152fb648333f0f2ab54bad2e4585"
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
