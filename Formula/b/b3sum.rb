class B3sum < Formula
  desc "Command-line implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.5.5.tar.gz"
  sha256 "6feba0750efc1a99a79fb9a495e2628b5cd1603e15f56a06b1d6cb13ac55c618"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9082de4e1d3f9390c44ff4f38d4e379509b2fec34517a3e1f9a5a9a09c0ada96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71e34b5afc894772d32d0d983499bd86d5ddff03023cf637d3390db4202cbc49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6db680bdafce5253681b4a7840b01367146682dc258f48a4c2a438f47595860"
    sha256 cellar: :any_skip_relocation, sonoma:        "6230145a2c86105180567a79296ebbae941f7091444238e83dac659a855d2df9"
    sha256 cellar: :any_skip_relocation, ventura:       "9a4948a3ead4ee1ffffb910b032627da971bb343c59bb3a64821c6c96c000a94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "064f2d5353a0cb664ebdb227d00cd6444e5fb3b0adb2a5e9f10ea9b0fd4cda83"
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
