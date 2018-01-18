class Platformio < Formula
  include Language::Python::Virtualenv

  desc "Ecosystem for IoT development (Arduino and ARM mbed compatible)"
  homepage "http://platformio.org"
  url "https://files.pythonhosted.org/packages/a4/34/c8a8ea8a8f8082b0f49f4cdf1978d9c7564fc4d70ab0b58dcb805c294b9a/platformio-3.5.1.tar.gz"
  sha256 "76f427e59be50f8ea8ab1cee97b721e9fb807ea3fd4a70e3f431dc037f2d8131"

  bottle do
    cellar :any_skip_relocation
    sha256 "b58672f9948cb66271ae3dd0d3e543435e03869c9f783f38091cd905aae591be" => :high_sierra
    sha256 "1d06ea9dc5cbe189f09bf494f86e9552c48b0decac7038bdd6ffe0261356cffd" => :sierra
    sha256 "14e5482183d4b412bee68f696f03f1bb722d675fb029db516f286c81b384c8bd" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/bd/99/04dc59ced52a8261ee0f965a8968717a255ea84a36013e527944dbf3468c/bottle-0.12.13.tar.gz"
    sha256 "39b751aee0b167be8dffb63ca81b735bbf1dd0905b3bc42761efedee8f123355"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/23/3f/8be01c50ed24a4bd6b8da799839066ce0288f66f5e11f0367323467f0cbc/certifi-2017.11.5.tar.gz"
    sha256 "5ec74291ca1136b40f0379e1128ff80e866597e4e2c1e755739a913bbc3613c0"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b7/34/a496632c4fb6c1ee76efedf77bb8d28b29363d839953d95095b12defe791/click-5.1.tar.gz"
    sha256 "678c98275431fad324275dec63791e4a17558b40e5a110e20a82866139a85a5a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/e6/76/257b53926889e2835355d74fec73d82662100135293e17d382e2b74d1669/colorama-0.3.9.tar.gz"
    sha256 "48eb22f4f8461b1df5734a074b57042430fb06e1d61bd1e11b078c0fe6d7a1f1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/cc/74/11b04703ec416717b247d789103277269d567db575d2fd88f25d9767fe3d/pyserial-3.4.tar.gz"
    sha256 "6e2d401fdee0eab996cf734e67773a0143b932772ca8b42451440cfed942c627"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "semantic_version" do
    url "https://files.pythonhosted.org/packages/72/83/f76958017f3094b072d8e3a72d25c3ed65f754cc607fdb6a7b33d84ab1d5/semantic_version-2.6.0.tar.gz"
    sha256 "2a4328680073e9b243667b201119772aefc5fc63ae32398d6afafff07c4f54c0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"platformio"
    system bin/"pio"
    system bin/"piodebuggdb", "--help"
  end
end
