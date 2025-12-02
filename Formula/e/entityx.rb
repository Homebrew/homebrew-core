class Entityx < Formula
  desc "Fast, type-safe C++ Entity Component System"
  homepage "https://github.com/alecthomas/entityx"
  url "https://github.com/alecthomas/entityx/archive/refs/tags/1.3.0.tar.gz"
  sha256 "2cd56d4fc5c553b786b8caf0b5bd9231434f21d43ca0e963d3bc5ee503a06222"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "83a257bcf2bbc1ca76e5148faf1a87945d4e987c575c12d3e6417cce65642a1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e9581dc9272c4aea13b72c38984aa2697cd705083fe55fc96a3b313402428cc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd01d453db532186781c5808a3a6f2f7e5c3ea91e83d3c7726426f196c8a66df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7573dbd39afa2fca718f2a0ce4167331d3662f6a287edaba5d5ba1f5158cfae0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "594046eaf8e36cc6a23376feb1d54bf7fd93a6bbf080781610f31aa8ec690ec8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "551746c5013a13ffc13157eb1bd6730c0cfd82027885651ec7c6939f1a2cbed0"
    sha256 cellar: :any_skip_relocation, sonoma:         "c098c8f4b5680803844e8eac84a91ad5c18428178284bde449bbc0c120855adb"
    sha256 cellar: :any_skip_relocation, ventura:        "32c94a4745f4b3458b8e3723c5c9bd26fc77266546bd9c8dd892c65115ff396f"
    sha256 cellar: :any_skip_relocation, monterey:       "72a593af59ba34b81679888bd0adb7adcfa32ea0d3078310a79f10f21a8cce1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0903e4a1357f44fa18f23b7d7223757e8047f28b8ce4d3e83f6334ea5ade720c"
    sha256 cellar: :any_skip_relocation, catalina:       "8e0e5b8ed56eaca89dadc59a78ede051c1f6eded8b7a9996fe33393e4d14bd0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d74139c6a3a5340831984319a46e10d0276b604a675d38c1cace40cd0329966a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ad5714ba0a1eb7c6929c02e05359f7b2f81a0389c867a1c1a98b07d1a0a14af"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DENTITYX_BUILD_SHARED=off
      -DENTITYX_BUILD_TESTING=off
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <entityx/entityx.h>

      int main(int argc, char *argv[]) {
        entityx::EntityX ex;

        entityx::Entity entity = ex.entities.create();
        entity.destroy();

        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lentityx", "-o", "test"
    system "./test"
  end
end
