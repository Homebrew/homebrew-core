class Pyperformance < Formula
  include Language::Python::Virtualenv

  desc "Python benchmark suite"
  homepage "https://github.com/python/pyperformance"
  url "https://files.pythonhosted.org/packages/9e/bc/ebc48f2af24abe0d13681ac7ccb21c3f0ed0128361522f5904d4f21953e9/pyperformance-1.14.0.tar.gz"
  sha256 "91f74393997b604375ad5b79bf569a24076d70181c076a53abad5383a238a8aa"
  license "MIT"
  head "https://github.com/python/pyperformance.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "99ce5f81c38fc29c5e8276aad5abeb64438b1e92dbb6e6d2a995aebb922c5a67"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "311bd9c8fa497645bf1b52ea724b05ab51f65226c8633b991158b7f62c493119"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa03097d651a4d16fbcf1c7fa9f4809753cabf8271bae759e3ae6e92e0761946"
    sha256 cellar: :any,                 arm64_linux:       "2e3c20a7de2b56e333f51ed18490df04fff5885aa27c91f2fce107755f419040"
    sha256 cellar: :any,                 x86_64_linux:      "d1d68571ec7a9bf4b5af6675aec8d75c03d78013484713aa332880c8f7ed4a62"
  end

  depends_on "python@3.15"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pyperf" do
    url "https://files.pythonhosted.org/packages/16/91/39ca77aa58f13e8c65d747ac7e06584b55acabfa98987fb8d546bc24860d/pyperf-2.10.0.tar.gz"
    sha256 "dd93ccfda79214725293e95f1fa6e00cb4a64adcf1326039486d4e1f91caaa62"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    list_output = shell_output("#{bin}/pyperformance list --benchmarks nbody")
    assert_match "'nbody' benchmarks:", list_output
    assert_match "- nbody", list_output

    groups_output = shell_output("#{bin}/pyperformance list_groups")
    assert_match "tags:", groups_output
  end
end
