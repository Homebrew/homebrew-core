class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "http://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/libcec-4.0.2.tar.gz"
  sha256 "b8b8dd31f3ebdd5472f03ab7d401600ea0d959b1288b9ca24bf457ef60e2ba27"

  bottle do
    cellar :any
    sha256 "9a629aa414001bceba73ac12a7c3748073b5698d5c0b9e086355dee1d8065297" => :mojave
    sha256 "8c30a121370d729e0dcfd6c536404f9934764cbb38de0e76ab970ddc243658c2" => :high_sierra
    sha256 "6e82912e61a59fde53faa863cc279adade8cfed868dc9ac3484106e5c56ef200" => :sierra
    sha256 "b444da5133858d153366c5aaed37c0980ea884b4697003a6b2729370be73d48c" => :el_capitan
    sha256 "368c2c4c012da197804a748601c3e9b576afa10669c5d6a5a40e31a3521aeddd" => :yosemite
  end

  depends_on "cmake" => :build

  resource "p8-platform" do
    url "https://github.com/Pulse-Eight/platform/archive/p8-platform-2.1.0.1.tar.gz"
    sha256 "064f8d2c358895c7e0bea9ae956f8d46f3f057772cb97f2743a11d478a0f68a0"
  end

  needs :cxx11

  def install
    ENV.cxx11

    resource("p8-platform").stage do
      mkdir "build" do
        system "cmake", "..", *std_cmake_args
        system "make"
        system "make", "install"
      end
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/cec-client", "--info"
  end
end
