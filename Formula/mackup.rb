class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/69/22/281e7a060e87343493ed3fdceaf0305947b6c99addb4ef70a2ff0bb0fc2e/mackup-0.8.34.tar.gz"
  sha256 "3a8a0700b72c274706ccea2d4c0d90109a29cda73a68b8c9357a06b919eefbb0"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fbee02bbc97cb8cb3fa7f18820e1e3a773fb830d80375f4fdc5edff9d2755c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fbee02bbc97cb8cb3fa7f18820e1e3a773fb830d80375f4fdc5edff9d2755c3"
    sha256 cellar: :any_skip_relocation, monterey:       "14aff8347df1a3a3cc7d2e787c1cc2b5f474a4b6392ac4fef129420fd4efaaee"
    sha256 cellar: :any_skip_relocation, big_sur:        "14aff8347df1a3a3cc7d2e787c1cc2b5f474a4b6392ac4fef129420fd4efaaee"
    sha256 cellar: :any_skip_relocation, catalina:       "14aff8347df1a3a3cc7d2e787c1cc2b5f474a4b6392ac4fef129420fd4efaaee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba4cdeab354afe203f8fe8a2d60a014233ef98be74d5a2f49d2e32e1409f4f73"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end
