class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "http://proselint.com"
  url "https://files.pythonhosted.org/packages/a2/be/2c1bcc43d85b23fe97dae02efd3e39b27cd66cca4a9f9c70921718b74ac2/proselint-0.13.0.tar.gz"
  sha256 "7dd2b63cc2aa390877c4144fcd3c80706817e860b017f04882fbcd2ab0852a58"
  license "BSD-3-Clause"
  head "https://github.com/amperser/proselint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86ce440b8382d55169bf8a5088e24123fa4ffbdff93a9bc1294c752de28985d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7932175feb36420223ffd74c73ea3c4c1a2fbd65ecfcb3070e3168dfe8d6cc34"
    sha256 cellar: :any_skip_relocation, monterey:       "0e85fb768662e4fbca5d5940138165331cf74c1ff6d9f63468a2d41280224a53"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba3901b022b0b7fbd1e2cf103630c32e4f2699f21e340e43483cbd2b06ba4dfc"
    sha256 cellar: :any_skip_relocation, catalina:       "d9a903907f6228bc99fa1ffea34f0bd6d91119a7730fb1e6ea93a074f06a56ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb8027460f8ffaf0acab19e6dbd12291b2115c440ade85105b67a76d302daff7"
  end

  depends_on "python@3.9"
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
