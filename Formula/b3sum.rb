class B3sum < Formula
  desc "The BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/0.3.5.tar.gz"
  sha256 "0f6892b7216291ab1a5b16cc40c01d7310b7d420ee38e779e5c45e49ca456e6b"
  license "CC0-1.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "db174a0353e2e4895e89fb42a8654e21434b148af904cf2a1cbbd93d2c5442c6" => :catalina
    sha256 "a755480f37ce92393530eaea18885657f05267b75944a3c8bd7d7f80b07ffe0a" => :mojave
    sha256 "95e4abcce1a09f891fa98f444a4e875a0b3f24c69e089937c5dd0df29fdebabc" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    cd "b3sum" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.txt").write <<~EOS
      content
    EOS

    output = shell_output("#{bin}/b3sum test.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  test.txt", output.strip
  end
end
