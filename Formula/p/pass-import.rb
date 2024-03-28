class PassImport < Formula
  include Language::Python::Virtualenv

  desc "Pass extension for importing data from most existing password managers"
  homepage "https://github.com/roddhjav/pass-import"
  url "https://files.pythonhosted.org/packages/f1/69/1d763287f49eb2d43f14280a1af9f6c2aa54a306071a4723a9723a6fb613/pass-import-3.5.tar.gz"
  sha256 "e3e5ec38f58511904a82214f8a80780729dfe84628d7c5d6b1cedee20ff3fb23"
  license "GPL-3.0-or-later"
  head "https://github.com/roddhjav/pass-import.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "490ac99e17f182fcd233b72bafcdde38ff4d7123d466a61d1909925c2a9e7d89"
    sha256 cellar: :any,                 arm64_ventura:  "38fc66c3299ecd2966773195a182dbc22395b2f91d62590d83ec153e2ef03946"
    sha256 cellar: :any,                 arm64_monterey: "1a0d87d58448c8945bd23c1b7a56f2afdfd91a35b94d18112f755ca6a06ec1a8"
    sha256 cellar: :any,                 sonoma:         "1a5db64090bc6e37ce6f672406778e6e3a43b1ca3c98cdbb48f400949cf7774e"
    sha256 cellar: :any,                 ventura:        "0b82daec994db8a7eeeebd1b2e27f0ee619d5dbeb911b6acc9e2d63a1befc1d7"
    sha256 cellar: :any,                 monterey:       "627a0f30024e874e8dca96f1b8e3766fa27060124fe462c3a4ce655e8f12bb42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aab526c1f56101cf9198009a8360c6a99fedb048d9c88091cc38da15e25fc9f"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
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
