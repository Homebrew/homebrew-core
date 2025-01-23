class Hex < Formula
  desc "Futuristic take on hexdump"
  homepage "https://github.com/sitkevij/hex"
  url "https://github.com/sitkevij/hex/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "7952ee2b6782e49259f82155c3b5287f1be72f15360a88e379c9270bd0d2416c"
  license "MIT"
  head "https://github.com/sitkevij/hex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "00163db8e16e993aea4f0695efa7742dd69be3b8c95fda5fd173116e6a95dab9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ba2edfeca426fad9d11610304e66413568579e8799fcd75233bb78b244c734b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12c69fa625d5767d73c6db34852bc5e407ea72f0e3323719cc12452be5a96aa2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "add8f34f654c08ee6bad65a9241ddf888f48671af80ed8802a28aeb0521c0ec1"
    sha256 cellar: :any_skip_relocation, sonoma:         "a68b4808c49f1efe490dda2257c7a086b49f06568217b69377d26f29579c6382"
    sha256 cellar: :any_skip_relocation, ventura:        "773540855a62a291de74084ecb0176d9d10b7451c447524c31de2e5916178931"
    sha256 cellar: :any_skip_relocation, monterey:       "32335343e695d99fe0e99e3f4d10900337d0b3994e0f4e5bb628a7ada5ccb643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b991de74c7ae7edad37b6c25c583a93de8cfd3cdc938bb00d978de0d80602bf5"
  end

  depends_on "rust" => :build

  conflicts_with "helix", because: "both install `hx` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"tiny.txt").write("il")
    output = shell_output("#{bin}/hx tiny.txt")
    assert_match "0x000000: 0x69 0x6c", output

    output = shell_output("#{bin}/hx -ar -c8 tiny.txt")
    expected = <<~EOS
      let ARRAY: [u8; 2] = [
          0x69, 0x6c
      ];
    EOS
    assert_equal expected, output

    assert_match "hx #{version}", shell_output("#{bin}/hx --version")
  end
end
