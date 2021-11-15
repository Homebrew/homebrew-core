class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/3.61.0.0.tar.gz"
  sha256 "46dcdcf06f3cf582170848721dd6d8ca9c993f9cfa34445103d3cee34a5d6dda"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:    "9ec907d3e43b34a000b90c9dfe31c2011d21fc36191a053b23074ea02db4a3fb"
    sha256 cellar: :any_skip_relocation, big_sur:     "adbdc903efa552e2c8d746a630b41c7f91406c9373f3b20c5bbafdc15c49afef"
    sha256 cellar: :any_skip_relocation, catalina:    "b11a948d232e02bf0ceaee439451f94ce48cc024b7737400b5ca21fbfe0aafb5"
    sha256 cellar: :any_skip_relocation, mojave:      "5915ea6038ff06703afa39cd989f62aa69cb3d0a0021acffb759a5a306312c78"
    sha256 cellar: :any_skip_relocation, high_sierra: "7690286795f26cc1fe240355e75a6cea19c8dddbb441e3a3e905c3a276f44191"
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
