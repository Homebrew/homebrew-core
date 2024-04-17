class PassImport < Formula
  include Language::Python::Virtualenv

  desc "Pass extension for importing data from most existing password managers"
  homepage "https://github.com/roddhjav/pass-import"
  url "https://files.pythonhosted.org/packages/f1/69/1d763287f49eb2d43f14280a1af9f6c2aa54a306071a4723a9723a6fb613/pass-import-3.5.tar.gz"
  sha256 "e3e5ec38f58511904a82214f8a80780729dfe84628d7c5d6b1cedee20ff3fb23"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/roddhjav/pass-import.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "51641e4cf1c8bf2628a9b1915e7661df9ae3a5bec4ebb39778d7daed4d8a475c"
    sha256 cellar: :any,                 arm64_ventura:  "ded7bc7ba4fe54ae17b501d076f4611254a1347b22c932758eace3b7afabe44a"
    sha256 cellar: :any,                 arm64_monterey: "c36d33dfb91a5092782ba779a1c2e333f355e2999d7c7ef9c391611915408560"
    sha256 cellar: :any,                 sonoma:         "141b81b98a8aea24a830af13a8c7f4fcbb44c31d1d8a0b565ce2a348edcbf721"
    sha256 cellar: :any,                 ventura:        "5404f90d176065a81f3b50eb6781dced5670b4b59483304192be5cf4a4d0ff15"
    sha256 cellar: :any,                 monterey:       "7540b0888dd14488e27e4b7fbd61bc649b26e63dcf7fbafb6910fd830bebc4c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd0b0d51939bae82b2ef847d4ee651fc3ed1c647d34394d1ffe6a552c2cf04b6"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "pyaml" do
    url "https://files.pythonhosted.org/packages/d0/3d/ddd68d7e8e0173f4ce450056835b759d986fa1cab7bf1a0fa142feed93cd/pyaml-23.12.0.tar.gz"
    sha256 "ce6f648efdfb1b3a5579f8cedb04facf0fa1e8f64846b639309b585bb322b4e5"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
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
