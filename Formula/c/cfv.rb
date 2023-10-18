class Cfv < Formula
  include Language::Python::Virtualenv

  desc "Test and create various files (e.g., .sfv, .csv, .crc., .torrent)"
  homepage "https://github.com/cfv-project/cfv"
  url "https://files.pythonhosted.org/packages/db/54/c5926a7846a895b1e096854f32473bcbdcb2aaff320995f3209f0a159be4/cfv-3.0.0.tar.gz"
  sha256 "2530f08b889c92118658ff4c447ccf83ac9d2973af8dae4d33cf5bed1865b376"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd204e237e4363490e5b674f2859ed641fadcbca5ecf6f16bc591c4907b1c9d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50269d4d596252ea86878243275fa520591b5d1265f6716751f326b85761b1cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "719e2978b0b1384b0755e8bcdfd54c42a4847c20ecde4e087caeed6b04089703"
    sha256 cellar: :any_skip_relocation, sonoma:         "a81236ef1d60b01c9fe0343648a82788b1812a12bd02a6c96823e331ef431249"
    sha256 cellar: :any_skip_relocation, ventura:        "c2f32bad443d50238558580ef9513f3eeaded2890c370f0d301abc53d387c5fd"
    sha256 cellar: :any_skip_relocation, monterey:       "d3900d70867cee31bfc595da20cca9b0beb68f1ca41d2e14c14741b453e6788f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "560380993073f6543d0ff516d56578525ec80108b863256b308ef0b9fa59829e"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test/test.txt").write "Homebrew!"
    cd "test" do
      system bin/"cfv", "-t", "sha1", "-C", "test.txt"
      assert_predicate Pathname.pwd/"test.sha1", :exist?
      assert_match "9afe8b4d99fb2dd5f6b7b3e548b43a038dc3dc38", File.read("test.sha1")
    end
  end
end
