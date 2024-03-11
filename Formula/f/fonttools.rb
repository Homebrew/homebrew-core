class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/52/c0/b117fe560be1c7bf889e341d1437c207dace4380b10c14f9c7a047df945b/fonttools-4.49.0.tar.gz"
  sha256 "ebf46e7f01b7af7861310417d7c49591a85d99146fc23a5ba82fdb28af156321"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4bb54e41b3370e2cabd6011aa7b77e11d28affe71b222b5ce22d1ebe0c5febfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4306f09e3c310a140a769827274be95ecc09e2184e03b5a5141a1e7819cb2edc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "833859026a9603c1a9c1db9c3ba260b2851d73ae9172579238ea3c645d059925"
    sha256 cellar: :any_skip_relocation, sonoma:         "5dc2a4e35044067c3f42d66c60ccad155fbb678c33e4ef7e0511c29c648b7155"
    sha256 cellar: :any_skip_relocation, ventura:        "ab26d3fe519388634a1d3e9fb266ae02d35ab8f0840b49e633bc4d5e3b5fdac9"
    sha256 cellar: :any_skip_relocation, monterey:       "9330d1fa382ea7e51d6e140adf988778088dd3172e464429927aa5a55276f898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e17061481ba51ea7b07a0af35ce327cddcab511a1bcfd25b5cf6e79f68dd86ea"
  end

  depends_on "python@3.12"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/92/d8/71230eb25ede499401a9a39ddf66fab4e4dab149bf75ed2ecea51a662d9e/zopfli-0.2.3.zip"
    sha256 "dbc9841bedd736041eb5e6982cd92da93bee145745f5422f3795f6f258cdc6ef"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath

      system bin/"ttx", "ZapfDingbats.ttf"
      assert_predicate testpath/"ZapfDingbats.ttx", :exist?
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_predicate testpath/"ZapfDingbats.woff2", :exist?
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
