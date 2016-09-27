class Grt < Formula
  desc "The Gesture Recognition Toolkit for real-time machine learning"
  homepage "https://www.nickgillian.com/wiki/pmwiki.php/GRT/GestureRecognitionToolkit"
  url "https://github.com/nickgillian/grt/archive/v0.0.1.tar.gz"
  sha256 "56f90a9ffa8b2bf4e5831d39f9e1912879cf032efa667a5237b57f68800a2dda"

  bottle do
    cellar :any
    sha256 "8c31e85370522a4db436657f0f5501f0fd20befc31b969a0c0db6c33ed12aed7" => :sierra
    sha256 "f48b42fd6f856239fb1f004a700aec5a85c129dc0a4a2b5955ce6a9a9721b231" => :el_capitan
    sha256 "aa26978c7029c36ab7d20a0e092968132e96255087f4155a1739db6dfcb9c170" => :yosemite
    sha256 "a3170758b555fe767a6c9b75940cdd3b22fe17740c7902bc4058ab7bd01d575f" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    cd "build"
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <GRT/GRT.h>
      int main() {
        GRT::GestureRecognitionPipeline pipeline;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lgrt", "-o", "test"
    system "./test"
  end
end
