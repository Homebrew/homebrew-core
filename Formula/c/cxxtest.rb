class Cxxtest < Formula
  desc "C++ unit testing framework similar to JUnit, CppUnit and xUnit"
  homepage "https://github.com/CxxTest/cxxtest"
  url "https://github.com/CxxTest/cxxtest/releases/download/4.4/cxxtest-4.4.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/c/cxxtest/cxxtest_4.4.orig.tar.gz"
  sha256 "1c154fef91c65dbf1cd4519af7ade70a61d85a923b6e0c0b007dc7f4895cf7d8"
  license "LGPL-3.0"
  revision 3

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf6a22bd6f8aea996598fa8ae48124229b7dc44e74d3979a1b6c6d4ede5c2c77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8f6e253ee11c1fdfefe7c63858e8148b7b15ff61d1624376e8d421d38d745ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c197b58b6de182aff18c51a2430308fd5f91f31e3dea2fc2f855cf2e722fcd2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5860db4123614951b76d55d21ad80e30b3212884395ed3646c699d25203a1d96"
    sha256 cellar: :any_skip_relocation, ventura:        "79caf0feacc783280f9b22b8b5cf0dfc26c3143d7cef151fcf8a28098bd04ee0"
    sha256 cellar: :any_skip_relocation, monterey:       "3ab69ebd42c09c08f68670153785c0bd67de032be7e49b09097584e0ea2b0925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "312674e4519fd0bd7c7c99fb00fc5c445963b0802a8286f9c32ec4dda3ea5237"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "./python"

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
