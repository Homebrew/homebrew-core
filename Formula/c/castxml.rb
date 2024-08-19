class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/refs/tags/v0.6.8.tar.gz"
  sha256 "b517a9d18ddb7f71b3b053af61fc393dd81f17911e6c6d53a85f3f523ba8ad64"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6a6ac1c558ad4289f70616bf82263fcc376a7b65457ef300a85b4b450baeb67a"
    sha256 cellar: :any,                 arm64_ventura:  "9dd34d3a642d6f223b3fc06295ddbd050c91333384109ccf5f0941dcc81350c5"
    sha256 cellar: :any,                 arm64_monterey: "9d9d0011b3375819cd8c78a0e6ddf51852482bb924c8ee9aa72af9ddbda4092b"
    sha256 cellar: :any,                 sonoma:         "369ed34afa1b9f615dd5ea4b516db04e515040ea25fde0cebf54e3d5f08ff891"
    sha256 cellar: :any,                 ventura:        "5e37026bc8dc4853a0fb8fb7a2459895502b94a3fe473e2029ccbf29c18e494a"
    sha256 cellar: :any,                 monterey:       "1df679a58e0764b752652f1892ec23e3d254923b0bfd650adcfba85d5d5b938d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "638b5864eeeea4cf53136547610a49ba9ae8189b9429a88410e4b86f7353e959"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system bin/"castxml", "-c", "-x", "c++", "--castxml-cc-gnu", ENV.cxx,
                          "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end
