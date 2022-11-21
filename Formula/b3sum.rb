class B3sum < Formula
  desc "BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/1.3.2.tar.gz"
  sha256 "31c1033009c55fdacafc87e0aaecf9e136fed3ccec6c637ed2461e487240b7da"
  license "CC0-1.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90112fe17c595d6577dc20f349a9484b8b32cc7138f424b2afface677921e677"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd3c175d3bb592d36fafd4e8e5cce09a707bfe4276a2efc9aa0d64383bc113f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c76e42e0d3d91e90b1bcac260a910b143be29608dcb8ee40e525ec997ceb46a"
    sha256 cellar: :any_skip_relocation, monterey:       "db5104502c09e960182033f046e1177cdf7ddbfe1850c097ee4f8f8a082ac71c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a64c1ed421184f85f6d1fa272cb8b5abbddf1d45f30e067ae260bf3fc0b547e"
    sha256 cellar: :any_skip_relocation, catalina:       "80ec0543e8478f8a42d3e8639b344e7126beb5ddd5f44aae6885e6cfaacf342f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af3297ae0793792914d5d93719c29ef52b6d598dbdce4d6b9e03229b232de645"
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
