class Forbidden < Formula
  include Language::Python::Virtualenv

  desc "Bypass 4xx HTTP response status codes and more"
  homepage "https://github.com/ivan-sincek/forbidden"
  url "https://files.pythonhosted.org/packages/9b/aa/98fc3ee28aac41cae341a197858ff6af5d79e40dcd45c8a6e37b1fdbfd19/forbidden-13.4.tar.gz"
  sha256 "dc987150b71515810d7ae252895b3ca6e077a8d9b3cbb0d09dfc9797c933a14d"
  license "MIT"
  head "https://github.com/ivan-sincek/forbidden.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5b554da93c74b675ffb4ddd0f975c400449aa862d63b0be91c57a8a3060e5b72"
    sha256 cellar: :any,                 arm64_sequoia: "d2d4ba0bd65b85991d20273c1327b2c9b2457fb32132d15607e7aca0a8d23b3d"
    sha256 cellar: :any,                 arm64_sonoma:  "52bfdf9db80dadcf0f887e57a486ca0658274207faaac7b02c53774fc027359a"
    sha256 cellar: :any,                 sonoma:        "72f6a922e3d10b39e079435254ab8b635b4ffc54e137733ee298b05b6bd6fd48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07ed61d346fddce4235e53797a567fc7475b4d06df46def290cf297961f5d8e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5c8a59e58ab3d7ac0419a3bd12c658a435f27afbe9b220a5b8ddede61476a1d"
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
    url "https://files.pythonhosted.org/packages/9a/26/d43128764a6f8fe1668c4f87aba6b1fe52bea81d05a35c84a70d3c70b6f7/alive-progress-3.3.0.tar.gz"
    sha256 "457dd2428b48dacd49854022a46448d236a48f1b7277874071c39395307e830c"
  end

  resource "bot-safe-agents" do
    url "https://files.pythonhosted.org/packages/44/8e/fd72545a981a5133b51802852bdb6d5a313a330b61cec952b3455456b9fd/bot_safe_agents-1.1.tar.gz"
    sha256 "ba3405bc92de1301fdd19b48e80ba7f26a8661ebbba2ab010e80e15267075ba6"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "graphemeu" do
    url "https://files.pythonhosted.org/packages/76/20/d012f71e7d00e0d5bb25176b9a96c5313d0e30cf947153bfdfa78089f4bb/graphemeu-0.7.2.tar.gz"
    sha256 "42bbe373d7c146160f286cd5f76b1a8ad29172d7333ce10705c5cc282462a4f8"
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
    url "https://files.pythonhosted.org/packages/49/d3/eaa0d28aba6ad1827ad1e716d9a93e1ba963ada61887498297d3da715133/regex-2025.9.18.tar.gz"
    sha256 "c5ba23274c61c6fef447ba6a39333297d0c247f53059dba0bca415cac511edc4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/ca/6c/3d75c196ac07ac8749600b60b03f4f6094d54e132c4d94ebac6ee0e0add0/termcolor-3.1.0.tar.gz"
    sha256 "6a6dd7fbee581909eeec6a756cff1d7f7c376063b14e4a298dc4980309e55970"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/forbidden -u https://brew.sh -t methods -f GET")
    assert_match "\"status\": 200", output
  end
end
