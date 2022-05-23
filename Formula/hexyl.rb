class Hexyl < Formula
  desc "Command-line hex viewer"
  homepage "https://github.com/sharkdp/hexyl"
  url "https://github.com/sharkdp/hexyl/archive/v0.10.0.tar.gz"
  sha256 "5821c0aa5fdda9e84399a5f92dbab53be2dbbcd9a7d4c81166c0b224a38624f8"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/sharkdp/hexyl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8181d65acc2b86f5f59e2f63519c2be162c265c9a57a02e7b933512578503cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e0868f9bceda9362ce7e7f662fe1bcf6c7d741ef5642eedff957f0b4bfb1714"
    sha256 cellar: :any_skip_relocation, monterey:       "4b3764d294f11a76d2d2394750ca0cb32965423f9344726ff07759be379f578b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad0cfe964706cdc3c2cf0b4b2714352442610b738e32ca24e6f7ffa26ed6bf37"
    sha256 cellar: :any_skip_relocation, catalina:       "892018bbf89c79a29a70b3b1485a2807b84626e44ff256d4bc4bc4d904192eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0910b917d78f2f7de1929e68fbb22425d3e5e0f314a7a4da2958798402f9e7fa"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    system "pandoc", "-s", "-f", "markdown", "-t", "man",
                     "doc/hexyl.1.md", "-o", "hexyl.1"
    man1.install "hexyl.1"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/hexyl -n 100 #{pdf}")
    assert_match "00000000", output
  end
end
