class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/45/40/94a4c9b4248dd3d1aa7c17a46e4cfbe493350d0d09548141223fbed6c0fa/fonttools-4.42.1.tar.gz"
  sha256 "c391cd5af88aacaf41dd7cfb96eeedfad297b5899a39e12f4c2c3706d0a3329d"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acfa78542160665f0f79a129eefd5471393581ce7b3d8fdee6221e13974d9775"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d51d9d8c32ec020e3a8dfebd20d9cab13620d4f5a9c024beeb4dc4f89a7af176"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31494f70ec21c16eb45b00188bdabb166f3ec2e41437fc7927e2765be8d203f5"
    sha256 cellar: :any_skip_relocation, ventura:        "a94b8713d5de261683e8249aed765f212917c7bff1fa2ba5cd6b0563c08fdd6a"
    sha256 cellar: :any_skip_relocation, monterey:       "7b7bce5a88ee88b41dc8c1396638929071aa4174dcbedfeed50523d4ddbf0c9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "34638df5d0d4adc9656b581b58255be27c387c16b287b7cad836d0d7b536b290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6212a1a9be533e156363326265ee948cb50d5757cb534fdc8c0d98a17bdd18eb"
  end

  depends_on "python@3.11"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
