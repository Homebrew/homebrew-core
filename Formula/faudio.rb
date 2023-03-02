class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/23.03.tar.gz"
  sha256 "59489129668ac3134c0483a0fea206db531550f0f5428f99aafec78626054551"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5465f9f1bbe90a8422c81c0ab8ce5cd75d8f3a2698fabc6e87b2f0ec1adc7bd1"
    sha256 cellar: :any,                 arm64_monterey: "e7c31a952aee6a93113d0cad7b43d8c844305056ad696a43854a3ed7603036b0"
    sha256 cellar: :any,                 arm64_big_sur:  "3cfced2d13605bbb78dc57d32426e6faafa5c46ec2a6626edc307f89b31b13a5"
    sha256 cellar: :any,                 ventura:        "9551e1e94695bce8298009b319b0d9a19a1ebe5ee011812678d790b9b961e50f"
    sha256 cellar: :any,                 monterey:       "96d8614fccf3ffe22588eadff991765476d699476dd20ff976bff299b2999cd1"
    sha256 cellar: :any,                 big_sur:        "9f675e279254e6651583a46be6fcad7c5fe8c5b7cb73d1ee145f4177e453231e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5117bb627f2f96d6a950b3e8f7848226b24fc0ff702026bd9bc5b85adc2cae42"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <FAudio.h>
      int main(int argc, char const *argv[])
      {
        FAudio *audio;
        return FAudioCreate(&audio, 0, FAUDIO_DEFAULT_PROCESSOR);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lFAudio", "-o", "test"
    system "./test"
  end
end
