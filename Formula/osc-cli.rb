class OscCli < Formula
  include Language::Python::Virtualenv

  desc "Official Outscale CLI providing connectors to Outscale API"
  homepage "https://github.com/outscale/osc-cli"
  url "https://files.pythonhosted.org/packages/e2/d3/2ff474be2543a868df1415f7a722d1b28016ee521982268e00b575adf0b9/osc-sdk-1.8.0.tar.gz"
  sha256 "a4184cf708f1b42017d40b441463c87dbdfba5a6b6660a032e7cdc250ac3bea5"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48773623a0424cbe66865313b28448fcb8f5a83af79de88b2dab4c2b1f7e0ce4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1afd0b19621994d2013ea1f20e4e88260c0dd1ced341f01efee1eaecc39b8bab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c87f69c3ba1c49c1f192dcb6bfd00d55c07c5d434d58acc071f121ba116dbea"
    sha256 cellar: :any_skip_relocation, monterey:       "bb74412e70d8c783a841212e656518ae0c97f36d2ac31182d5ca9da9559b7a41"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c981f9f00d88b3d62b67f226f84f5f9294967f06c2cd555ff42de7918cc5dfa"
    sha256 cellar: :any_skip_relocation, catalina:       "16ac8424a9232da4b9396691359cd3972d8f1575ff72d48e35899e405d893f75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6589b9b5f9422da0c42420f5164961b7c602f7b6ff2d6fa3ca9cfe5701716a3d"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "fire" do
    url "https://files.pythonhosted.org/packages/11/07/a119a1aa04d37bc819940d95ed7e135a7dcca1c098123a3764a6dcace9e7/fire-0.4.0.tar.gz"
    sha256 "c5e2b8763699d1142393a46d0e3e790c5eb2f0706082df8f647878842c216a62"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/62/1a/e78a930f70dd576f2a7250a98263ac973a80d6f1a395d89328844881a0c0/termcolor-2.1.0.tar.gz"
    sha256 "b80df54667ce4f48c03fe35df194f052dc27a541ebbf2544e4d6b47b5d6949c4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # we test the help wich is printed in stderr :(
    str = shell_output("#{bin}/osc-cli -- --help 2>&1 >/dev/null")
    assert_match "osc-cli SERVICE CALL <flags>", str
    str = shell_output("#{bin}/osc-cli api ReadVms 2>&1 >/dev/null", 1)
    assert_match "No configuration file found in home folder", str

    mkdir testpath/".osc"
    (testpath/".osc/config.json").write <<~EOS
      {
        "default": {
          "access_key": "F4K4T706S9XKGEXAMPLE",
          "secret_key": "E4XJE8EJ98ZEJ18E4J9ZE84J19Q8E1J9S87ZEXAMPLE",
          "host": "outscale.com",
          "https": true,
          "method": "POST",
          "region_name": "eu-west-2"
        }
      }
    EOS

    str = shell_output("#{bin}/osc-cli api ReadVms 2>&1 >/dev/null", 1)
    match = "raise OscApiException(http_response)"
    assert_match match, str
  end
end
