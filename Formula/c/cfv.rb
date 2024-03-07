class Cfv < Formula
  include Language::Python::Virtualenv

  desc "Test and create various files (e.g., .sfv, .csv, .crc., .torrent)"
  homepage "https://github.com/cfv-project/cfv"
  url "https://files.pythonhosted.org/packages/db/54/c5926a7846a895b1e096854f32473bcbdcb2aaff320995f3209f0a159be4/cfv-3.0.0.tar.gz"
  sha256 "2530f08b889c92118658ff4c447ccf83ac9d2973af8dae4d33cf5bed1865b376"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6d455648ea1ee84968c57bd0218341c5acee3e594e97d24e53b6ea1dfedc666"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42b4b04b3a9cd67ec440afaa45db5115d06d1019cbe21c987b53e680a173415a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e32838b7338414d95863daea12afa2085d38e577f2320feaa2b7bc64eeae425"
    sha256 cellar: :any_skip_relocation, sonoma:         "b676890c309cbe870ddfbaef65bd4540236fe4f4b8a6cceeb0291be95d317f06"
    sha256 cellar: :any_skip_relocation, ventura:        "2078439fda829127a701e088d395df2ee279cea6052c72ea38b4efec41ca5e67"
    sha256 cellar: :any_skip_relocation, monterey:       "4b56673702488afba8ecbc1a524bc580f5dbff0ce1601636f454c05393295f12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "398b65a6b3495ccc1cff405108a5db678ca99b6b7c3d355fcf450c8ec2ea3ea9"
  end

  depends_on "python@3.12"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  def install
    # fix man folder location issue
    inreplace "setup.py", "'man/man1'", "'share/man/man1'"

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
