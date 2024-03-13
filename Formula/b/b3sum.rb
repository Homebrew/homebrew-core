class B3sum < Formula
  desc "Command-line implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.5.1.tar.gz"
  sha256 "822cd37f70152e5985433d2c50c8f6b2ec83aaf11aa31be9fe71486a91744f37"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39351e8b4165518ef1a78fa0813aac39bd69c133a28391d6fe5d2440ccdd053a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e52fe62d4c9c1865bf556e2e8df87412aa3157fba71baeea164c58d035699ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea172430052c4fdedc7db18e3beb79933a14d1b9643122282d8686064796d620"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f493ad59ac1f1b03ad2a232132b936de0568fbef1b89dfba6eb744f9db686e2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ab351124e74784e62eea2dee55cd3e0675764bb12774cbe35969dba8203d22f"
    sha256 cellar: :any_skip_relocation, ventura:        "eb131c612af885ebdac7e3d790ecee6b6aaa7a00c05e3d7e3b48c53f597d6ce5"
    sha256 cellar: :any_skip_relocation, monterey:       "1a3b9f0f8c76068f2eb6705290d74dd8d0f2918fa0fa2ca5ad821a80cd841bc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b35c6499acf324f5000994b89f918c9b8fbec293b4d71f3ed5b54717d891b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4275864db35cf03f6a91e37db0353d3f4856d3f656068db44a784f1a89161211"
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
