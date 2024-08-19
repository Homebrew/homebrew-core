class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://huacnlee.github.io/autocorrect/"
  url "https://github.com/huacnlee/autocorrect/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "c29b065db7733ede2da152dd8eb1be44dad86ec345e406715b8b487b1f9cd81d"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ea22ef12c16dfa27eecac001844ac360da8cb99adcf850b34a4177735b0ae70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "740565f33ef62699e9626fc19398b25bf45fd90a5baaea1f4e95a1e9eaf36a1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "467c779941ef6ee5959d611e39a1a95d651b8d72907755fcf9f503f5970edbe4"
    sha256 cellar: :any_skip_relocation, sonoma:         "501af42cafafe55fb780445d9dfc3e064460fe27da6338984029fb9e9801c218"
    sha256 cellar: :any_skip_relocation, ventura:        "60543b3ae4a76771e2a4fbfcde0d8a36603a2ed125c6f7cc3ad7360d0880347d"
    sha256 cellar: :any_skip_relocation, monterey:       "89d1e3e7393eab2b09eaab6d59de7e69f80cb6effb6cb6bcab02b4069ed05cca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cafdadcb921c8c8fb3e67ff21cddff0c89cdbb3aa762c3b1e201ebc623b61a41"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_match "Hello 世界", out

    assert_match version.to_s, shell_output("#{bin}/autocorrect --version")
  end
end
