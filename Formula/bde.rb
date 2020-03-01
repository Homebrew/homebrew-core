class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/3.39.0.0.tar.gz"
  sha256 "e16f0821e925f23de279f72cfd2b2ff23ae344979a4b285d9d63abd4f759f329"

  bottle do
    cellar :any_skip_relocation
    sha256 "127e8d71924e5f06e13a1d08fd3ea22a099609e1f69434dce229c4b3aeb0fc34" => :catalina
    sha256 "f8a7566aaefef652418c0bebca94619c0e47877b25c11f88b57c2c09f157afe6" => :mojave
    sha256 "4e8255cc3614d7d93e632d28ab697e5ad5749d5f9b463a4dc467466a596a4271" => :high_sierra
    sha256 "605cff2b1687632dd90ffacc48cee0d1890415816379f8f63814411810a88d74" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/v1.1.tar.gz"
    sha256 "c5d77d5e811e79f824816ee06dbf92a2a7e3eb0b6d9f27088bcac8c06d930fd5"
  end

  def install
    buildpath.install resource("bde-tools")

    ENV.cxx11

    system "python", "./bin/waf", "configure", "--prefix=#{prefix}"
    system "python", "./bin/waf", "build"
    system "python", "./bin/waf", "install"
  end

  test do
    # bde tests are incredibly performance intensive
    # test below does a simple sanity check for linking against bsl.
    (testpath/"test.cpp").write <<~EOS
      #include <bsl/bsl_string.h>
      #include <bsl/bslma_default.h>
      int main() {
        using namespace BloombergLP;
        bsl::string string(bslma::Default::globalAllocator());
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}/bsl", "test.cpp", "-L#{lib}", "-lbsl", "-o", "test"
    system "./test"
  end
end
