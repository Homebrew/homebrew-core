class Forbidden < Formula
  include Language::Python::Virtualenv

  desc "Bypass 4xx HTTP response status codes and more"
  homepage "https://github.com/ivan-sincek/forbidden"
  url "https://files.pythonhosted.org/packages/ed/80/eb80e899c8ac2357aa9b001600e64177a1a68c32b466becadf1eb0a09e01/forbidden-13.2.tar.gz"
  sha256 "e560b121b1419393695505a4bf61ab82230a34bffc9b1779ca75a33ab3f62916"
  license "MIT"
  head "https://github.com/ivan-sincek/forbidden.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2245b94b8c99ed3559cc4adb14dd697f91470ed94a9deee99f747db03a25022e"
    sha256 cellar: :any,                 arm64_sonoma:  "b477ba383c03cea30975ed2963b0fcd32b7a1ff7f667f1c6330560abf189857d"
    sha256 cellar: :any,                 arm64_ventura: "18eb7d97360f621c07c4f49e408940a273be58e051212720fb93c57522d464eb"
    sha256 cellar: :any,                 sonoma:        "65007aa53d56c3695b661ead36a7f80c7fa8265bee1e2535c0944887a2b1673d"
    sha256 cellar: :any,                 ventura:       "288400dd51340b542c352fb9899300fea07a2a2a528e785274c4a79eebf3697e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "247ee447bea00d027b98995b8ceb448946dba48aeacfbc03eed32cc302b90002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7b94130c1ae5812ca69f9492c9155eed553c1dfef6799066429acb99ff58ce3"
  end

  depends_on "certifi"
  depends_on "cffi"
  depends_on "cryptography"
  depends_on "curl"
  depends_on "openssl@3"
  depends_on "pycparser"
  depends_on "python@3.13"

  resource "about-time" do
    url "https://files.pythonhosted.org/packages/1c/3f/ccb16bdc53ebb81c1bf837c1ee4b5b0b69584fd2e4a802a2a79936691c0a/about-time-4.2.1.tar.gz"
    sha256 "6a538862d33ce67d997429d14998310e1dbfda6cb7d9bbfbf799c4709847fece"
  end

  resource "alive-progress" do
    url "https://files.pythonhosted.org/packages/28/66/c2c1e6674b3b7202ce529cf7d9971c93031e843b8e0c86a85f693e6185b8/alive-progress-3.2.0.tar.gz"
    sha256 "ede29d046ff454fe56b941f686f89dd9389430c4a5b7658e445cb0b80e0e4deb"
  end

  resource "bot-safe-agents" do
    url "https://files.pythonhosted.org/packages/6a/06/a557cece31bdf2992db8099f3e0e3296e955cf681f0cab4a5dc89779c984/bot_safe_agents-1.0.tar.gz"
    sha256 "8b2d9e435ec10a89563b10a6ca977bbf8fb43cf4eca7d8e412e2e69c8aff400c"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "grapheme" do
    url "https://files.pythonhosted.org/packages/ce/e7/bbaab0d2a33e07c8278910c1d0d8d4f3781293dfbc70b5c38197159046bf/grapheme-0.6.0.tar.gz"
    sha256 "44c2b9f21bbe77cfb05835fec230bd435954275267fea1858013b102f8603cca"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/71/35/fe5088d914905391ef2995102cf5e1892cf32cab1fa6ef8130631c89ec01/pycurl-7.45.6.tar.gz"
    sha256 "2b73e66b22719ea48ac08a93fc88e57ef36d46d03cb09d972063c9aa86bb74e6"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/e7/46/bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726/pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/37/72/88311445fd44c455c7d553e61f95412cf89054308a1aa2434ab835075fc5/termcolor-2.5.0.tar.gz"
    sha256 "998d8d27da6d48442e8e1f016119076b690d962507531df4890fcd2db2ef8a6f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/forbidden -u https://brew.sh -t methods -f GET")
    assert_match "\"status\": 200", output
  end
end
