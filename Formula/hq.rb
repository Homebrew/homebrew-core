class Hq < Formula
  desc "Jq, but for HTML"
  homepage "https://github.com/orf/hq"
  url "https://github.com/orf/hq/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "6f761a301a38b27d7be9b536100003f361fecaf42639750d3c86096ec56a90b9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cff53a43f503e0644bbbc92de06930c0749803ee3f1f023bbf01c2fdd07b16d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57be49537a52e41624625837dd35930b781ce36ee900815ccc3b256a01b0c11f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "937957dd55b632a67eddadf1ed0e7d15b809ee4dd37549589756798e2d1c53ce"
    sha256 cellar: :any_skip_relocation, ventura:        "d87d07c29cae2dd8b4c9c6a5cb66b17132a89626afe50b952168a6784434db72"
    sha256 cellar: :any_skip_relocation, monterey:       "8b5d397148f2813a49e4e747cfa255ab58698bf4603ed2da0286f40531f6959f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d3baf2ab4bad36322799d4bd2b0b231c638f7c35ada04e22aea4ff9fdedbab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1491eddae8407b039b3abb4f5a1ed9e4fdf4065d6a9c04c77e4fe07a2f953534"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    html = testpath/"test.html"
    html.write <<~EOS
      <p class="foo">Test</p>
    EOS
    output = shell_output("#{bin}/hq '{foo: .foo}' test.html")
    assert_match '{"foo":"Test"}', output
  end
end
