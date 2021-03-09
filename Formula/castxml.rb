class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/v0.4.3.tar.gz"
  sha256 "3dd94096e07ffe103b2a951e4ff0f9486cc615b3ef08e95e5778eaaec667fb65"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "491a35b5d5f447a622b0a1a4d030831ac260835f48821fda9dab19c1093fb177"
    sha256 cellar: :any, big_sur:       "4b2c5ff139602b7519205387709e386878f773cca651d690a78062decf4f2df0"
    sha256 cellar: :any, catalina:      "3fff50f3bcc6d6b3087e305a5ad891921b713d28421f9ce44b59b95ad2433461"
    sha256 cellar: :any, mojave:        "7aab32dadf0f6ba727cda4c187e4fde21d7d1c48156b3e1e607846bad1908c3a"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system "#{bin}/castxml", "-c", "-x", "c++", "--castxml-cc-gnu", "clang++",
                             "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end
