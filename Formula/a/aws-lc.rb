class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v1.65.0.tar.gz"
  sha256 "27d2ac24a961888efb1fcc6443ea5e611942f783e017e0c178af95d05431b808"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "593a71352843ca950b68f34fdb03c50f5e2ae1a36e9d1c710ad992b127e89bb9"
    sha256 cellar: :any,                 arm64_sequoia: "f27a9b49347499431febdc242cbbc54f5d399460e07a5e6ec74481684c3227d8"
    sha256 cellar: :any,                 arm64_sonoma:  "f635cf5bd5540ad47b70a8d676144b8091042b0eb56c492bed020c1a8e07f3c2"
    sha256 cellar: :any,                 sonoma:        "aa25fb046594bd0904af16ccc6bbf4eb793db034ae5f77a41f560612b43aef92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "180940653d727a31fe8ee2031a50c1159005e9537d0f22f262812674e6284ab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40318515170faaed227e016e99d405f54f390ddefecb87240c8aa37fe5e9eb4f"
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
