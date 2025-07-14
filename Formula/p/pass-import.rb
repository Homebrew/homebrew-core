class PassImport < Formula
  include Language::Python::Virtualenv

  desc "Pass extension for importing data from most existing password managers"
  homepage "https://github.com/roddhjav/pass-import"
  url "https://files.pythonhosted.org/packages/f1/69/1d763287f49eb2d43f14280a1af9f6c2aa54a306071a4723a9723a6fb613/pass-import-3.5.tar.gz"
  sha256 "e3e5ec38f58511904a82214f8a80780729dfe84628d7c5d6b1cedee20ff3fb23"
  license "GPL-3.0-or-later"
  revision 5
  head "https://github.com/roddhjav/pass-import.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "59113cfc585169c49622aff41d2e9d816d3e44df9978d5b3c80d469abf6e879d"
    sha256 cellar: :any,                 arm64_sonoma:  "434d68c3443172d74cba7292657dc1e9e9a03c1ce1c781cb7002cc34d701d8ff"
    sha256 cellar: :any,                 arm64_ventura: "0063ce827cea806f2223ae3c01c57912e06716770911f630c864271698880d89"
    sha256 cellar: :any,                 sonoma:        "886c4535d374cd68f9902119b43c9733a23f0c99fdd0879aa682c9e01bda9425"
    sha256 cellar: :any,                 ventura:       "99635afc19cd18f9c90d538d0e21ca0f71fb4dc7110320b451cc375fc016d3e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c26ce676ee18c6e0b30305d8808a9bf22d6baa9dbef19a1d359c96fe7f4710c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9d80cb51ceebc3365946d91bd31998ad42b6808d136221c06c32f1358bf3179"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "pyaml" do
    url "https://files.pythonhosted.org/packages/c1/40/94f10f32ab952c5cca713d9ac9d8b2fdc37392d90eea403823eeac674c24/pyaml-25.5.0.tar.gz"
    sha256 "5799560c7b1c9daf35a7a4535f53e2c30323f74cbd7cb4f2e715b16dd681a58a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "zxcvbn" do
    url "https://files.pythonhosted.org/packages/ae/40/9366940b1484fd4e9423c8decbbf34a73bf52badb36281e082fe02b57aca/zxcvbn-4.5.0.tar.gz"
    sha256 "70392c0fff39459d7f55d0211151401e79e76fcc6e2c22b61add62900359c7c1"
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
