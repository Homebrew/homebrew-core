class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v1.52.1.tar.gz"
  sha256 "fe552e3c3522f73afc3c30011745c431c633f7b4e25dcd7b38325f194a7b3b75"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbf44050a27bee919aebf08b15e04b94ac5bf3cc199095528ec5491ae62c4f41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aaf5ae03f79818056ec1f6c48e6a2e96f6dc2b9bfbca860625e5b2514b1bca1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9d138a916f1a239a408c700a9f7535c6fe195184aac5f507e4d57afa20c2f1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3d2bb8939ebf0abf42e8ff0314b8e2605fa274120f129ca974f88aae8c48332"
    sha256 cellar: :any_skip_relocation, ventura:       "ecffb698b128d28cb65e2bbfe7af7e5fe6ade8c5bf19f9b09d4e6d635ac1e32c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1fe3ba72954fd2b8fd9583a8ed32cf1f6f454dc9ff3606edd3a7ef75553913e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a727de42d27915134728a280d757edce0ee63a666c190821ca6a1c562dc33f60"
  end

  keg_only "it conflicts with OpenSSL"

  depends_on "cmake" => :build
  depends_on "go" => :build

  uses_from_macos "perl"

  def install
    args = %w[
      -DCMAKE_INSTALL_INCLUDEDIR=include
      -DCMAKE_INSTALL_BINDIR=bin
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
