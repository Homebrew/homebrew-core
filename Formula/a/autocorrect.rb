class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://huacnlee.github.io/autocorrect/"
  url "https://github.com/huacnlee/autocorrect/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "5a8496ff9ff647a8babe148d87a652aedb40aefb514017193692259791ba686d"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38c02c11d5f615c5ca71f25c4bfcae8a4dab59634511f625372686059b2fa8cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3c468bff0670fc17839924cc870ca55ef6b0ec681c8bf411b0758252a48029f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff80841327b79b88038718943e0af76a436bba5f9fa2560a8e29b02cc9f853af"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1b86c63d8e92521b27556a81e51ed6e11d9b716268054c927011d139ac88489"
    sha256 cellar: :any_skip_relocation, ventura:        "7ea93444c42c32b459e4d290bd8a3a18fa907f84fdf4619ea5e8c887bd1aa219"
    sha256 cellar: :any_skip_relocation, monterey:       "949908c3c1b4b8de06cff3674df73d95e20e0fd9804368b523a0532a8303ba42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17ca415f3b2277a2b2e68cd8eca1fa7bf8bdb05fd214fb923c529089e8367119"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_equal "Hello 世界", out
  end
end
