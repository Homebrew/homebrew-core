class Pywhat < Formula
  include Language::Python::Virtualenv

  desc "🐸 Identify anything: emails, IP addresses, and more 🧙‍♀️"
  homepage "https://github.com/bee-san/pyWhat"
  url "https://files.pythonhosted.org/packages/32/18/94ed2965c98f2577826bf642bd496516738c3056c824687c1453c2e88944/pywhat-1.1.0.tar.gz"
  sha256 "445cfe9ac2ccffd8438d4d4197fc5ec0ebbfac1ec241a75cd2e65ea5ed68e615"
  license "GPL-3.0-only"
  head "https://github.com/bee-san/pyWhat.git"

  depends_on "python@3.9"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "langdetect" do
    url "https://files.pythonhosted.org/packages/0e/72/a3add0e4eec4eb9e2569554f7c70f4a3c27712f40e3284d483e88094cc0e/langdetect-1.0.9.tar.gz"
    sha256 "cbc1fef89f8d062739774bd51eda3da3274006b3661d199c2655f6b3f6d605a0"
  end

  resource "name-that-hash" do
    url "https://files.pythonhosted.org/packages/83/b4/bd1ad28c46023baa8af4a813ee31298c4d3d81937886e900f56af04d634a/name-that-hash-1.9.0.tar.gz"
    sha256 "77f848196b339ec2ae8dc7f2ec1197401eb7cb9605f880c7813b342251e5cf89"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/1e/cc/ced09195051b5384e9a82d6de7fc1a3917017fe214d30d41a9935cea465d/rich-10.2.2.tar.gz"
    sha256 "17b3f486c38e79cc219d8848974b277ef532a82d12b3ad6eb37bb8c6f22ab5fc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "Possible language (ISO-639-1 code): et 100% probability.", pipe_output("#{bin}/pywhat test").strip
  end
end
