class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "http://proselint.com"
  url "https://files.pythonhosted.org/packages/a2/be/2c1bcc43d85b23fe97dae02efd3e39b27cd66cca4a9f9c70921718b74ac2/proselint-0.13.0.tar.gz"
  sha256 "7dd2b63cc2aa390877c4144fcd3c80706817e860b017f04882fbcd2ab0852a58"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/amperser/proselint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "699747e7855830ae0811ee1c43e421e651acaf1c9d63e11e77bc8bbf48803fa6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25aedee29b1cf3e7e209aad66b37a4ba29673ef7f52a515f02196c4114c71a8a"
    sha256 cellar: :any_skip_relocation, monterey:       "6d6ec687b47919c8e959f98699adf00f2f39560b7c057c2c006efb9ce73cc431"
    sha256 cellar: :any_skip_relocation, big_sur:        "7308b866170e550ff04917a632f6975c338f4fe505c65243740083e9df0aa135"
    sha256 cellar: :any_skip_relocation, catalina:       "00fa37c1f98845d77dc8466f249ae0edc8bb12e24c26bbc0ebca1d15c8404765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02f3545e37bf0c95d02262d54eb0d3ad27e71e4f2082e05f44aadb4ebf949b85"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/proselint --compact -", "John is very unique.")
    assert_match "Comparison of an uncomparable", output
  end
end
