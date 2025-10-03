class Fruit < Formula
  desc "Dependency injection framework for C++"
  homepage "https://github.com/google/fruit/wiki"
  url "https://github.com/google/fruit/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "ed4c6b7ebfbf75e14a74e21eb74ce2703b8485bfc9e660b1c36fb7fe363172d0"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "4bda90128aa536a15d5e5cff13df7542d5070289c6c16674915b3470ab6046b9"
    sha256 cellar: :any,                 arm64_sequoia:  "ecf666939daa1621d37416639a69c85c8b75c73ee09cfdfdad8613296097c2cd"
    sha256 cellar: :any,                 arm64_sonoma:   "4431afb2b1e7cd70c1b91fd33c656b7a51207ce63f7c21c078549da987cb6e3d"
    sha256 cellar: :any,                 arm64_ventura:  "f9b3bb2a148bbb31068abfb84093dfd3f56fab05b8ed1badd8fda26bab828d80"
    sha256 cellar: :any,                 arm64_monterey: "7267ab542431d4adfd542a1801341f94bc6bcd951869b7d5739e7423526f3653"
    sha256 cellar: :any,                 arm64_big_sur:  "28fe9f0bfb79fbc39048389e2e329e1f84b51a491522c622197c61a54ef835ee"
    sha256 cellar: :any,                 sonoma:         "76cfc99b1622805e2a51012911d1c9d1fbea28d6832f52654b0fc0850f472229"
    sha256 cellar: :any,                 ventura:        "90a9e9ed4c7b5009627bd46e107f3697b310e022e2e1ba0efe05dd0bcb049fd1"
    sha256 cellar: :any,                 monterey:       "8cf43ab558179955f4f110e54ab27083a062070a3e684badfdf0b567eb524548"
    sha256 cellar: :any,                 big_sur:        "7b46f22a641fcec38ca7784157fd876639618d541cf0b1c4ac783d0b9db48627"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6cbe793d133f5e840dc23feeac8ad00715283b2cbc2645580175ca4c2be8a2cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e67f3fbe98944d1758385a4f188435b4b81b7fc5a192fe2c9c1a6e37e6b8d7cb"
  end

  depends_on "cmake" => :build

  # Update cmake_minimum_required for compatibility with CMake
  # Remove on next release.
  patch do
    url "https://github.com/google/fruit/commit/b731fdb6426b07bd6674d2d9a057ad13c8e247e7.patch?full_index=1"
    sha256 "dacdf25c966dba2df55526c3c77a036ef48ac1f8fc7a53b17c0e87492963d0f7"
  end

  def install
    system "cmake", "-S", ".", "-B", "_build", "-DFRUIT_USES_BOOST=False", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    pkgshare.install "examples/hello_world/main.cpp"
  end

  test do
    cp_r pkgshare/"main.cpp", testpath
    system ENV.cxx, "main.cpp", "-I#{include}", "-L#{lib}",
           "-std=c++11", "-lfruit", "-o", "test"
    system "./test"
  end
end
