class Entityx < Formula
  desc "Fast, type-safe C++ Entity Component System"
  homepage "https://github.com/alecthomas/entityx"
  url "https://github.com/alecthomas/entityx/archive/1.3.0.tar.gz"
  sha256 "2cd56d4fc5c553b786b8caf0b5bd9231434f21d43ca0e963d3bc5ee503a06222"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "551746c5013a13ffc13157eb1bd6730c0cfd82027885651ec7c6939f1a2cbed0"
    sha256 cellar: :any_skip_relocation, big_sur:       "0903e4a1357f44fa18f23b7d7223757e8047f28b8ce4d3e83f6334ea5ade720c"
    sha256 cellar: :any_skip_relocation, catalina:      "8e0e5b8ed56eaca89dadc59a78ede051c1f6eded8b7a9996fe33393e4d14bd0e"
    sha256 cellar: :any_skip_relocation, mojave:        "5d2b3d80d9be39b08b61003fe0f8c30bf8aec792636b78e475fbbbb55d3e01a7"
    sha256 cellar: :any_skip_relocation, high_sierra:   "b015609cd7e4ad7154e846a34e91627a605983ab3e3f1767df5ccf7e46cc9d10"
    sha256 cellar: :any_skip_relocation, sierra:        "d0ecde656ac88f1f312d69894a32330827cd52ac64a7e20d1357a0a9bbe8d596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ad5714ba0a1eb7c6929c02e05359f7b2f81a0389c867a1c1a98b07d1a0a14af"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DENTITYX_BUILD_SHARED=off", "-DENTITYX_BUILD_TESTING=off", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include <entityx/entityx.h>

      int main(int argc, char *argv[]) {
        entityx::EntityX ex;

        entityx::Entity entity = ex.entities.create();
        entity.destroy();

        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lentityx", "-o", "test"
    system "./test"
  end
end
