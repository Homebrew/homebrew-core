class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v1.72.0.tar.gz"
  sha256 "f214c0e06e043c4f18b836059ccb5ecbed781173e8eed106839ee2dd4f4cc157"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "168c29f5af4463f651fab4b97c9d57d8a50c3f848617c6a86179516568258e2f"
    sha256 cellar: :any,                 arm64_sequoia: "1d58b341259649f8fee55b6ea8300643f73c0834097295944c7da7b393e5e1b4"
    sha256 cellar: :any,                 arm64_sonoma:  "ab4f3f892e56f618c85440b507a0a0e492c7fc4b7fb20971acc8d4d99899cdc4"
    sha256 cellar: :any,                 sonoma:        "460852758b1d5e5425d34c0a0bc34d43311f5d25148bb07bd7d98cf911bfcf69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f480d6f6315cf97fad55f4140be49624c728b7e41cdb90a7958c74ad2e9dd37a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2448d310ddb7033d6c0ae41c551d185e10eb47b2726114618d91661fc42cd2d"
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
