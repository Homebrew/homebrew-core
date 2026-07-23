class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v5.4.0.tar.gz"
  sha256 "ef310fdb20a4172a357ab60a1adb217b21aceb34f02e29758edec5a02b1bcc0f"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6b37246f83791e4a63821810d897bbe1ea6e7e7c30b54adc158f106dd3ca445e"
    sha256 cellar: :any, arm64_sequoia: "788f03e6f42f1801521e4ac82a206bb034bb4e8d1a2ca09c857381cfe3d0e26f"
    sha256 cellar: :any, arm64_sonoma:  "0ab5b47a411fd1d280759c4f3510c2f9b7e493787df0bca939c68cfa2ade025c"
    sha256 cellar: :any, sonoma:        "4cb1a1274a5c9f51e5d6cacd1693641d436d998740078e052df564491d4c36e3"
    sha256 cellar: :any, arm64_linux:   "7b962c4146dd54ef53f4c2d496c4587ab31e2cb7519b9b55619c2d9bd1daa3e9"
    sha256 cellar: :any, x86_64_linux:  "6fafd478afa22c2eff829ef33181a241184d4e644b2723a45f4841d404463938"
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
