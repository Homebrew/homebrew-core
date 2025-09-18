class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.12.0/c/avro-c-1.12.0.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.12.0/c/avro-c-1.12.0.tar.gz"
  sha256 "74333d431079c35d770cef6996cb4de04058d19e81bd0b9a363bcfd38575037f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "592ba6d381848c72396130bb795a9f4c5b6d8014bba6ef420f1ee35209a72cd1"
    sha256 cellar: :any,                 arm64_sequoia: "55a7ac0c245aa1a110e06f25ed5aab22922fc762de9a61576ae9a8cf22e150bd"
    sha256 cellar: :any,                 arm64_sonoma:  "acc150596eca0d7da0c04d277ee91b6cf126b22f7e71751638ab09ee76da7448"
    sha256 cellar: :any,                 arm64_ventura: "2193d76cd4bf35b5d69c89befe5a10d0f0673c4fdedc62d7dcbc4b8e43315217"
    sha256 cellar: :any,                 sonoma:        "3394bb8ba4ea17797d835e77ec0cea484a563d4d58aca0d53bbadf754afe0bb9"
    sha256 cellar: :any,                 ventura:       "3f5f2cdd8bdcc59291607247041f5b83a59481eb7c37e9ec9df26c1f9c5b41ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa594ba05dbc282f35d49a75872f849187fb7172125fd70780ecee7498f37d70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bbc7d593ae823c31de41337ae70b81254fe04ff700a4d514e18f5f4992e2586"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "jansson"
  depends_on "snappy"
  depends_on "xz"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-example" do
      url "https://raw.githubusercontent.com/apache/avro/88538e9f1d6be236ce69ea2e0bdd6eed352c503e/lang/c/examples/quickstop.c"
      sha256 "8108fda370afb0e7be4e213d4e339bd2aabc1801dcd0b600380d81c09e5ff94f"
    end

    testpath.install resource("homebrew-example")
    system ENV.cc, "quickstop.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lavro"
    assert_match "Silent |  (555) 123-6422 | 29 |", shell_output("./test")
  end
end
