class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/refs/tags/v0.6.11.tar.gz"
  sha256 "fc5b49f802b67f98ecea10564bc171c660020836a48cecefc416681a2d2e1d3d"
  license "Apache-2.0"
  revision 1
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eb8bfd73cd5084290714fc8b1d773f0f147db2bc0665ed332151f29834d46e96"
    sha256 cellar: :any,                 arm64_sonoma:  "913ce01b2d817286d48a0af0cc5ad1cf1ddbd2e8366ede27649d7bbd8c49a22b"
    sha256 cellar: :any,                 arm64_ventura: "fbfd5d97b197709dd42bb5ba6a8c6238a85b1b8115041174f678bf7057660767"
    sha256 cellar: :any,                 sonoma:        "096c7cd9c0d9b1b9e7693a6399ef577ca7ca8213809596302feed1926d000a57"
    sha256 cellar: :any,                 ventura:       "aeedfc94d23a3f6d276ca9586afbf9179777118959c6ec5c6ba124c74a2df5d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b99443e08a4f18a60fd9427272b99b2328be6a73a6f7d3787fa9b092b95a8d8"
  end

  depends_on "cmake" => :build
  depends_on "llvm@19"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      int main() {
        return 0;
      }
    CPP
    system bin/"castxml", "-c", "-x", "c++", "--castxml-cc-gnu", ENV.cxx,
                          "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end
