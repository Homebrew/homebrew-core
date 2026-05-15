class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v1.73.0.tar.gz"
  sha256 "e33ae89e7d09d7b23a900f68b62088d8813c260ac564b016e543ee3540ebcce3"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "33ef936404fa4c93a4d7bfb54ed773aa8b1d53c73176d9c611755c3592a840e3"
    sha256 cellar: :any,                 arm64_sequoia: "82bb3a5b0fe5f6213d9e1b41fb186cc71fac33211285fecafee9d4869382bf46"
    sha256 cellar: :any,                 arm64_sonoma:  "94c8c79c4745b1112b9b8d74b4eeb08e19bc648f07bf3f67a4b038d18c3d6a80"
    sha256 cellar: :any,                 sonoma:        "b7b8e0f66e8569a9cc68027d0bd5b211758804f6756002d80af76bb20a65964b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56446f774eef6fdb097597afa9c8cb5f791a41197eee872da98bf10f9df1bf42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6b3ae9e6786fdf949351f6d311d5b270a04032b345acf30ed7cf3f94cf24e31"
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
