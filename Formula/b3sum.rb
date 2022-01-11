class B3sum < Formula
  desc "BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/1.3.0.tar.gz"
  sha256 "a559309c2dad8cc8314ea779664ec5093c79de2e9be14edbf76ae2ce380222c0"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dccdd1d7c2d9b8e636f4d78eb1cd1166ab4b4ac69e89f223961ecf5d386e753"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db0c593c16f5276fb385b03582f261b723da5a8f21709be8b60ec229e7fad462"
    sha256 cellar: :any_skip_relocation, monterey:       "83b7139a768b15dcfe60da80469aa8a3f750e0dbca4af479dc20fc110ffba825"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef4df03c023bce47f2de992ba824801a40004ef34a481fe67e19158f51512813"
    sha256 cellar: :any_skip_relocation, catalina:       "27b9260e41f47be3d2961f04f1cada4b60a9d0485ecca1ff053db435bb444968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "871dd9192e62a72b35215d3876482822c2b8085f01554a27a615debf85195ea0"
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
