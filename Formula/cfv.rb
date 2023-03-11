class Cfv < Formula
  include Language::Python::Virtualenv

  desc "Test and create various files (e.g., .sfv, .csv, .crc., .torrent)"
  homepage "https://github.com/cfv-project/cfv"
  url "https://files.pythonhosted.org/packages/db/54/c5926a7846a895b1e096854f32473bcbdcb2aaff320995f3209f0a159be4/cfv-3.0.0.tar.gz"
  sha256 "2530f08b889c92118658ff4c447ccf83ac9d2973af8dae4d33cf5bed1865b376"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38eaeb7bfcf83dbf9ab48ad9a1a0d4a71a91ae830792397c5424e8cd743ad5de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09dd4b6432d6cac583e1ac82d2d65c10f2d3549f4d7a1017dbcce07ae6123238"
    sha256 cellar: :any_skip_relocation, monterey:       "a71d821fcf88da93b92fc6c8443a63e1bf14474e74bcff47026474146c8c58a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ce1654aa4805deb6a80b9ec470306b879b79d5e25e151df1e4c78e498c0e214"
    sha256 cellar: :any_skip_relocation, catalina:       "cd4fac08aac6490ade28d8b370e006c720bab5df939caadb92b25af278a4384a"
    sha256 cellar: :any_skip_relocation, mojave:         "251348813c0a811e6ac298432967d19e42bfa73bbc3217eaa0b63bec4b78d98d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7452ead7901f4f4ab2683cd391af82f856eba1a57c11d07c038ca18507535dac"
    sha256 cellar: :any_skip_relocation, sierra:         "449f4b10a0371005f04bffa6271364824a83fbb68cb15208168c19457b987b6e"
    sha256 cellar: :any_skip_relocation, el_capitan:     "49b83783b5737a364504fdd9fd09672134e0103c7bb8152741d67fca455fde04"
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
