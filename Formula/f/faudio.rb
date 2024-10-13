class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/24.10.tar.gz"
  sha256 "9d123c5f20ead7824f718b5840b87b432dbf51a0514214e30c41b4ee32a344e0"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ce8247177d54550211702a13c418cc243d1035aec60684057ec98316c962ae84"
    sha256 cellar: :any,                 arm64_sonoma:  "06d082b71a48a42d79c8b0eee9e328b18ddb0e00fcc69f48bc59dfd12d23fed8"
    sha256 cellar: :any,                 arm64_ventura: "d0222fa949501b83ee23bee4c4168e15d874084e47a1a243cc5063085cd5eb82"
    sha256 cellar: :any,                 sonoma:        "3c0d4aa208663ba5011139e6449793c8444caa4e8721bf0313d9f8d297beb306"
    sha256 cellar: :any,                 ventura:       "e38584cc332fad98e20690bc8d656cd883a703df267fb8044f9903a47ecce26e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ec2485cace2e4875630c2ba9c12d7eada0f5e77c0131c0032e8c3c9b76f500b"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
