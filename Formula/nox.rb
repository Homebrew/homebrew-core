class Nox < Formula
  include Language::Python::Virtualenv

  desc "Flexible test automation for Python"
  homepage "https://nox.thea.codes/"
  url "https://files.pythonhosted.org/packages/0f/7b/2c61a41827dd4409acee48a9126312ee6be11597285577c26ecbebbaa591/nox-2022.1.7.tar.gz"
  sha256 "b375238cebb0b9df2fab74b8d0ce1a50cd80df60ca2e13f38f539454fcd97d7e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baa9596244e98d45ef28e0ff4316885ee19688e0a651c4803018b80bcb61d9ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80761ecfb43b5bd5c76a6c95852f4cc38596b64589696feb57c9d20710ed4990"
    sha256 cellar: :any_skip_relocation, monterey:       "8db95db32b4f023428eefe565821c5c5a525fa4254eb295a927d27ebc42b6f09"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbdd76e33b499bed1ec56ae22298058c4d0145426d6d3e43dadf845d86252ef8"
    sha256 cellar: :any_skip_relocation, catalina:       "27a312df4eafd728d166c5bbbf0c43d8b85544f76985d0d278c7b9ad4bb99a03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f528d5fa463185d1106cacc53a6afc72e75e7645b7359c671a923ad50394e5c6"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6a/b4/3b1d48b61be122c95f4a770b2f42fc2552857616feba4d51f34611bd1352/argcomplete-1.12.3.tar.gz"
    sha256 "2c7dbffd8c045ea534921e63b0be6fe65e88599990d8dc408ac8c542b72a5445"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/8e/8f/1537ebed273d43edd3bb21f1e5861549b7cfcb1d47523d7277cab988cec2/colorlog-6.6.0.tar.gz"
    sha256 "344f73204009e4c83c5b6beb00b3c45dc70fcdae3c80db919e0a4171d006fde8"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/85/01/88529c93e41607f1a78c1e4b346b24c74ee43d2f41cfe33ecd2e20e0c7e3/distlib-0.3.4.zip"
    sha256 "e4b58818180336dc9c529bfb9a0b58728ffc09ad92027a3f30b7cd91e3458579"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/11/d1/22318a1b5bb06c9be4c065ad6a09cb7bfade737758dc08235c99cd6cf216/filelock-3.4.2.tar.gz"
    sha256 "38b4f4c989f9d06d44524df1b24bd19e167d851f19b50bf3e3559952dddc5b80"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/be/00/bd080024010e1652de653bd61181e2dfdbef5fa73bfd32fec4c808991c31/platformdirs-2.4.1.tar.gz"
    sha256 "440633ddfebcc36264232365d7840a970e75e1018d15b4327d11f91909045fda"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/98/ff/fec109ceb715d2a6b4c4a85a61af3b40c723a961e8828319fbcb15b868dc/py-1.11.0.tar.gz"
    sha256 "51c75c4126074b472f746a24399ad32f6053d1b34b68d2fa41e558e6f4a98719"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/ab/61/1a1613e3dcca483a7aa9d446cb4614e6425eb853b90db131c305bd9674cb/pyparsing-3.0.6.tar.gz"
    sha256 "d9bdec0013ef1eb5a84ab39a3b3868911598afa494f5faa038647101504e2b81"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/f1/db/4498de0294f0c72a2e0a099d1588e7b55d0c849db740c89978ff73700519/virtualenv-20.13.0.tar.gz"
    sha256 "d8458cf8d59d0ea495ad9b34c2599487f8a7772d796f9910858376d1600dd2dd"
  end

  def install
    virtualenv_install_with_resources
    (bin/"tox-to-nox").unlink
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"noxfile.py").write <<~EOS
      import nox

      @nox.session
      def tests(session):
          session.install("pytest")
          session.run("pytest")
    EOS
    (testpath/"test_trivial.py").write <<~EOS
      def test_trivial():
          assert True
    EOS
    assert_match "usage", shell_output("#{bin}/nox --help")
    assert_match "1 passed", shell_output("#{bin}/nox")
  end
end
