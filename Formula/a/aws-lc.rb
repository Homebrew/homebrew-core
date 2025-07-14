class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v1.55.0.tar.gz"
  sha256 "a216e5e572ad9f68e6b93666f0bbca4d7792f400ca525731583196c139c12ce9"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c4110694c59b32c0fa5f9ac6bdcf46b3bab857e4c14d771ebea3a96f77ffac8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "927ed35a38b2807d4af664d77db494df5e8d167cb48ce1a54b2a49edff1eedb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d6782f75c9216d44572b9985e8955074bfe3d230cfaae67c95587ff6eb70db8"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfaeabc98ba337c433ca79b659fbb3331f4bac3171901f28aa172ede182a5811"
    sha256 cellar: :any_skip_relocation, ventura:       "014ee01a7510223792bf527b5d04237e0549075e55c4d30ccc112752946f1279"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7af85d5f112d8c769f371b1cd35d1a505ea0b320c05bb8b336ca9100532d7055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "948e8d3dab4e0e1dbeb215e07a5f676a4eeaa89bbc403669423a8a9a62f3458a"
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
