class B3sum < Formula
  desc "BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/1.0.0.tar.gz"
  sha256 "5a4e29b7d687779805bd3e4e345df063ccdde085204bc31d4c516da6a28caa0a"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3c79b2e1a99c15e34a16704464a6da8c0f8192cfbbeb402764ef33b948ad9dde"
    sha256 cellar: :any_skip_relocation, big_sur:       "c84ed5e1116845343fc0db6cd71acbae101d59fe614e0eb10f584dd2bc85a6aa"
    sha256 cellar: :any_skip_relocation, catalina:      "b4041a76b7b285d0e08ad2f88bee08864f3c5557aa1d98d24479c5f11e7b063f"
    sha256 cellar: :any_skip_relocation, mojave:        "a519019495263bc5ecc038829e45bf78495de1ea4e1a04f90a9888198f7b9986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b710a42418a6d2c530352d301ef405b10f606e02da957726f6f29c28fb3beea3"
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
