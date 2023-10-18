class Hexyl < Formula
  desc "Command-line hex viewer"
  homepage "https://github.com/sharkdp/hexyl"
  url "https://github.com/sharkdp/hexyl/archive/v0.13.1.tar.gz"
  sha256 "a4b3009aa7210f7d80f91d6b01543d1544586c4509247f01e028f1a56781056d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/hexyl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24b78a507119069ffea77bea1ba2fd3b001e688bbf4b6354f9ba39eb68f7bc3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b93fa28a29a7a0c2805eeb8edb4376fb603164271afb86a4c4e4c49b709e86b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be47c1fb56bedd308995fd3237810cdffe0c7a3082511ec2c26945691ff88027"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e11d55f97ce14bd95816ab657a5c3c03d3c3d3787ebbe3383cb0926035d64ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "88478226a05e029721562361d688979feac5f04f96819566c87a85d3f3052d3f"
    sha256 cellar: :any_skip_relocation, ventura:        "80eceabf20efb94166dd01b6a7806704c37503d3e73e99e600f41559ce968538"
    sha256 cellar: :any_skip_relocation, monterey:       "7cea9f2c4578595bfb9fbc0774144ef21d1840eaddde29961dba1d936d0f323a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3558dae5138227ee363ccd715fa73a22c9a9bb21804f1d43f84877cf652889f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bb38b2d67aaf522cf2b002eee87af133b0760ede5f18082dbf7013c0e4d52b6"
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
