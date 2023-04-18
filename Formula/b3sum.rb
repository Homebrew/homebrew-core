class B3sum < Formula
  desc "BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/1.3.3.tar.gz"
  sha256 "27d2bc4ee5945ba75434859521042c949463ee7514ff17aaef328e23ef83fec0"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e444ed506f694350e9862bf5ccc5fa7b80a0a50a6dfc5dbd91f0968050ce024d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18107cbb5e59f87c8bbc8d200b8271867b7512620ea2c3813b38e00b3c2b842d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63887a445a74e816d2065e68156deb565fca9d4ca90a5298b9d91fb83b8249bc"
    sha256 cellar: :any_skip_relocation, ventura:        "d5253008aad354c52a504b62c62e28dc9dbe871aa3e3f97845ebbeab2bf32a5a"
    sha256 cellar: :any_skip_relocation, monterey:       "4d9ffc0feafd47e79aa4b6b21bad7f59461f8d025dbf0d9b7ac238de42b633d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b251e81c461b59e9c231e24a5551693054c0fabb4c3ccec79b773e6d6f17c230"
    sha256 cellar: :any_skip_relocation, catalina:       "f846f17b8780e0cf413a908db621f2a065abc48af37f71ca10dccdc65591dbac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd24ecea8e6226dacde3b0a9d72b921ba25cefcffe6860649f1db3d3ad49e7b3"
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
