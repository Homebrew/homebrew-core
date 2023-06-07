class Cfv < Formula
  include Language::Python::Virtualenv

  desc "Test and create various files (e.g., .sfv, .csv, .crc., .torrent)"
  homepage "https://github.com/cfv-project/cfv"
  url "https://files.pythonhosted.org/packages/db/54/c5926a7846a895b1e096854f32473bcbdcb2aaff320995f3209f0a159be4/cfv-3.0.0.tar.gz"
  sha256 "2530f08b889c92118658ff4c447ccf83ac9d2973af8dae4d33cf5bed1865b376"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f826a41136bc033c173de5b9759e9e6ce0902895558db00cb0a0fd403bdb312a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f826a41136bc033c173de5b9759e9e6ce0902895558db00cb0a0fd403bdb312a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f826a41136bc033c173de5b9759e9e6ce0902895558db00cb0a0fd403bdb312a"
    sha256 cellar: :any_skip_relocation, ventura:        "bb57fa29453a2dd671eae3ecdfeb5d54e7139a28e5d231e488ddd36edd42f99f"
    sha256 cellar: :any_skip_relocation, monterey:       "bb57fa29453a2dd671eae3ecdfeb5d54e7139a28e5d231e488ddd36edd42f99f"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb57fa29453a2dd671eae3ecdfeb5d54e7139a28e5d231e488ddd36edd42f99f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f25c7b64de0e58996b6b1f0315799082bea2149a2be5e88aafe6355b7cf50d41"
  end

  depends_on "python@3.11"

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
