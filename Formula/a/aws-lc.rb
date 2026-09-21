class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v5.9.0.tar.gz"
  sha256 "f7b7b1a85bcc30496b98173257d69cc2990ae85d380b642ebe0b8cb251876d4f"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6906182acc26988ed72273ef5c3ae79c8a5cee9e78701bf8c7e65ee2db814563"
    sha256 cellar: :any, arm64_tahoe:       "077861768de476d617d97751686d4ffe35492b6881c7a85ae52b74399216931f"
    sha256 cellar: :any, arm64_sequoia:     "4f4a1f9347761b23e83f0686eff9043ea5a244d490fc2991b514dc1b9ec667dc"
    sha256 cellar: :any, arm64_linux:       "a4a7f5ae016a530f3931f9a93e8c9ac6a32ee8dbec751adb39d821b97dd391b2"
    sha256 cellar: :any, x86_64_linux:      "8620c344ae61916e385df93c1eb8d67f45bb09d769abec56ba6fee40eaebdebb"
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
