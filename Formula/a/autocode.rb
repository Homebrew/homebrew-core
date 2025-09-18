class Autocode < Formula
  desc "Code automation for every language, library and framework"
  homepage "https://autocode.readme.io/"
  url "https://registry.npmjs.org/autocode/-/autocode-1.3.1.tgz"
  sha256 "952364766e645d4ddae30f9d6cc106fdb74d05afc4028066f75eeeb17c4b0247"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "abf59dcf5fe4c66882ff2e33b395fd733f43b831e983592b530160dd3bb94c1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b77a0c5a2addfbdb49c0c77c50d5ef04b56462c3882588527dba9bbb81feefd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f91b10fe03c30d860728b43972b1d261bf0bcd51eaaff8bb086a7f68f69c76a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc6e30959f70b915afd2f6808c21150f2b818d9ea2bce0990aa81a960ff185ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "829180e4ff87058eedda5560d335a3e1e35ae8ae37747e4be41cde83e505c3a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "780c41a7ada390dbefa61b56497f4cf53f9a5db0094b38c7064f9a4c21177fff"
    sha256 cellar: :any_skip_relocation, sonoma:         "3dacf760cebe889c2c0bb16cf51ecd74c0ec96b51476282ae16ec96c1ef66953"
    sha256 cellar: :any_skip_relocation, ventura:        "70efb3eb2cd71248d2b6f239752f5e8155beab4f8cb33f9f6542aa58ac779e3a"
    sha256 cellar: :any_skip_relocation, monterey:       "cde7f8b32745f8ab929ace5952dafdec15cabdf92d2a96ab67ddeaad5479bee0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddfc5b923a862daf2c1489d942e83f03dc99fdb3dcb2b7eebd67e92582174867"
    sha256 cellar: :any_skip_relocation, catalina:       "451224479d19854f4f802b0ec63077080df91196917ad14d16e4a2308f247527"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f1e4d0a241cbecda677088d390da59e754c90f1236a101c6b36e5d3df6d3fc77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "186b5262fed77462a1b2407dbd2106ebf80f9e1c48fd56bf57549f6716156f96"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".autocode/config.yml").write <<~YAML
      name: test
      version: 0.1.0
      description: test description
      author:
        name: Test User
        email: test@example.com
        url: https://example.com
      copyright: 2015 Test
    YAML
    system bin/"autocode", "build"
  end
end
