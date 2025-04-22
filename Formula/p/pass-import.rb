class PassImport < Formula
  include Language::Python::Virtualenv

  desc "Pass extension for importing data from most existing password managers"
  homepage "https://github.com/roddhjav/pass-import"
  url "https://files.pythonhosted.org/packages/f1/69/1d763287f49eb2d43f14280a1af9f6c2aa54a306071a4723a9723a6fb613/pass-import-3.5.tar.gz"
  sha256 "e3e5ec38f58511904a82214f8a80780729dfe84628d7c5d6b1cedee20ff3fb23"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/roddhjav/pass-import.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "e2263e0d94a2fd744c5748f9cd6a3966fc11ae33deca1ffb34e5997b47c2dafc"
    sha256 cellar: :any,                 arm64_sonoma:  "bf43aba56684c5ae1ff7be2b57090632c4a0a14dc7ae95223dbc89fe3e87b6e5"
    sha256 cellar: :any,                 arm64_ventura: "590406753c0fe6cb030055867702051112366e5f7d199f9341f860222b544513"
    sha256 cellar: :any,                 sonoma:        "175a6f288828c380052249095a738b05c5e81741ab3061ba975494433827aee1"
    sha256 cellar: :any,                 ventura:       "475bc32225a5f5b3edc4339b83e0a69b68a4156ea3e3bf7f2c994249a40fd817"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bf7123a1879198f333664b612cb03ea9c7620ca00f41961b2fe6bb42b59127a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27a3f4f49b185cb3996cf80ee3026d58dec59e21da067caddf3832189d31c39f"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "pyaml" do
    url "https://files.pythonhosted.org/packages/fd/a6/5b51160ff7ce60b0c60ec825359c0e818b0ce4a2504fa3dd1470f42f9b10/pyaml-24.9.0.tar.gz"
    sha256 "e78dee8b0d4fed56bb9fa11a8a7858e6fade1ec70a9a122cee6736efac3e69b5"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "zxcvbn" do
    url "https://files.pythonhosted.org/packages/54/67/c6712608c99e7720598e769b8fb09ebd202119785adad0bbce25d330243c/zxcvbn-4.4.28.tar.gz"
    sha256 "151bd816817e645e9064c354b13544f85137ea3320ca3be1fb6873ea75ef7dc1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    importers = shell_output("#{bin}/pimport --list-importers")
    assert_match(/The \d+ supported password managers are:/, importers)

    exporters = shell_output("#{bin}/pimport --list-exporters")
    assert_match(/The \d+ supported exporter password managers are/, exporters)
  end
end
