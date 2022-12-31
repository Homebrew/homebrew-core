class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/f1/11/79902a32afed6e1ccd8db0f937ff6027fcdb1118602013910fc1fed9b50f/jc-1.22.4.tar.gz"
  sha256 "4088d599834eea242538dbd4011d3efd8fa0d2a43887d6813a904309f040bdaa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e828f7791a33a2e06538d27675f8bb72185e00b9960c77d14f00e0c1ba6fbdba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e828f7791a33a2e06538d27675f8bb72185e00b9960c77d14f00e0c1ba6fbdba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e828f7791a33a2e06538d27675f8bb72185e00b9960c77d14f00e0c1ba6fbdba"
    sha256 cellar: :any_skip_relocation, ventura:        "b2a5c7933d0377f50f4fb9cb64d47e7ba9a16e312f09e8df2756cef897807905"
    sha256 cellar: :any_skip_relocation, monterey:       "b2a5c7933d0377f50f4fb9cb64d47e7ba9a16e312f09e8df2756cef897807905"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2a5c7933d0377f50f4fb9cb64d47e7ba9a16e312f09e8df2756cef897807905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c49fb1455a991b9904aec1f3b7189d45978657fb658b0d65fb758907e8aee196"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
    man1.install "man/jc.1"
    generate_completions_from_executable(bin/"jc", "--bash-comp", shells: [:bash], shell_parameter_format: :none)
    generate_completions_from_executable(bin/"jc", "--zsh-comp", shells: [:zsh], shell_parameter_format: :none)
  end

  test do
    assert_equal "[{\"header1\":\"data1\",\"header2\":\"data2\"}]\n", \
                  pipe_output("#{bin}/jc --csv", "header1, header2\n data1, data2")
  end
end
