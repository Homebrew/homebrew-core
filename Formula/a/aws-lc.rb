class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "a6bf6adfc5f9bba559d28554b7d3581b15f2813f03bc9f2ae19f0d915e97dadf"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9637cadbfbe5465148e80f5e446544ad84fec58cfaf3cfd35ad6f32b37c0eb8b"
    sha256 cellar: :any, arm64_sequoia: "a8b2a49a18b13b765cb12078ffd2dfdbb5aa973c6c68d0676d262c8ec2c2477f"
    sha256 cellar: :any, arm64_sonoma:  "e9ed2975774f4ea07741145afbe288092d6271348315cbae34b8028541abf6fd"
    sha256 cellar: :any, sonoma:        "9121924b0d91323792066c0627cce4c8038f94fec1495fb388275851c51c5fac"
    sha256 cellar: :any, arm64_linux:   "8ec54bddad20cb9335a92e1005a51af59a6875e1309ee6470a1b73e1a00e63a2"
    sha256 cellar: :any, x86_64_linux:  "d1ff58c1e1ebaa30f0a9a67b34f23b15436059f082837a9e1662eef680ec0943"
  end

  keg_only "it conflicts with OpenSSL"

  depends_on "cmake" => :build
  depends_on "go" => :build

  uses_from_macos "perl"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_BINDIR=bin
      -DCMAKE_INSTALL_INCLUDEDIR=include
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args

    # The jitter entropy collector must be built without optimisations
    ENV.O0 { system "cmake", "--build", "build", "--target", "jitterentropy" }

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    output = shell_output("#{bin}/bssl sha256sum testfile.txt")
    assert_match expected_checksum, output
  end
end
