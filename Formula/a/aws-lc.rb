class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v1.53.0.tar.gz"
  sha256 "b7c3a456df40c0d19621848e8c7b70c1fa333f9e8f5aa72755890fb50c9963de"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b32e904617a7d2edd9f48806dafbd628c5228cb81a3ad1bdbf0eeb5fa3d7e954"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7080e7a9dddea84e7b65acafd236c04bc27df75c8a6e5a3a6ceebce6095cda88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fbd353cb57b9f146d1228c1083736dddd8f4545ceb3ad2e3ea7193e442e186a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "cee9654455ffd802e4c0edad0387d73bc01aab0b3103db97d2d0df4ffe625e52"
    sha256 cellar: :any_skip_relocation, ventura:       "a243f0710a9799c4f5a3f779b783b83c0dd451c402ff74836045e079feb6a5f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ee5f863f1d9f5a422348eb7d75e43c4dae8450074ecd64222709a6e1fc9e4b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "886cc92b621687abeb5ac0325c11fc542a03e6169e83d3bf6ba19ebeac9ef806"
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
