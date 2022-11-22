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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53c5150a7e3d4482836d9fd72cfdc4257ae2efea60f12af941874045aa05a069"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ff8f8f8ef7bb4b0fb56369770bd24e6516044d0e403d9a5a7eb72ff73bed9e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6e14cd993003d73da10b027c1b970c53d99506cd0f1b773c67592d3e12b8681"
    sha256 cellar: :any_skip_relocation, ventura:        "3990779414e97f32ac8262b906fdb3f24bcc890b7b4e2692b19b34d10464edab"
    sha256 cellar: :any_skip_relocation, monterey:       "5855ad203a93a97d78b54b9fc22efd40e9fddf8f51aae9c7d20f7234a3c62f82"
    sha256 cellar: :any_skip_relocation, big_sur:        "097182dbeeb8fcaeaa3b3bd40b690cd9f8026c760bc177b8d764f346e23d1c76"
    sha256 cellar: :any_skip_relocation, catalina:       "880b7bf9d6348fe8b2845971f37429c210d66836a054a20e7fe3de01bdcba2e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a188af82c223211e586acbdb3fd80561cbf9c0a963e128fa305aa55e0d0d1b78"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
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
