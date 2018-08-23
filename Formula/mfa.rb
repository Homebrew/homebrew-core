class Mfa < Formula
  include Language::Python::Virtualenv

  desc "Multi-factor authentication on your command-line"
  homepage "https://pypi.python.org/pypi/mfa"
  url "https://github.com/limeburst/mfa/archive/0.1.1.tar.gz"
  sha256 "1db41a7cc1215f44ea7ddb8e0e2d8a97f2a924b46660bbab71fa64cc332a859d"

  depends_on "python"

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/27/e8/607697e6ab8a961fc0b141a97ea4ce72cd9c9e264adeb0669f6d194aa626/entrypoints-0.2.3.tar.gz"
    sha256 "d2d587dde06f99545fb13a383d2cd336a8ff1f359c5839ce3a64c917d10c029f"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/a0/c9/c08bf10bd057293ff385abaef38e7e548549bbe81e95333157684e75ebc6/keyring-13.2.1.tar.gz"
    sha256 "6364bb8c233f28538df4928576f4e051229e0451651073ab20b315488da16a58"
  end

  resource "mfa" do
    url "https://files.pythonhosted.org/packages/2c/ae/4e0a6053c8a5394b9d4a283346c7d9f9c559a22ccd1118ed10db9a9919cc/mfa-0.1.1.tar.gz"
    sha256 "9c30da365f3f56ec8e921178b495b0fff1fbbe6dfd2877900d8e4ce3aabe84ba"
  end

  resource "onetimepass" do
    url "https://files.pythonhosted.org/packages/aa/b2/cb6832704aaf11ed0e471910a8da360129e2c23398d2ea3a71961a2f5746/onetimepass-1.0.1.tar.gz"
    sha256 "a569dac076d6e3761cbc55e36952144a637ca1b075c6d509de1c1dbc5e7f6a27"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    shell_ouput("#{bin}/mfa set key value")
    output = shell_ouput("#{bin}/mfa get key")
    assert_equal "value", output.chump

   end
end
