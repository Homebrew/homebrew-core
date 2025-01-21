class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https://github.com/liquidctl/liquidctl"
  url "https://files.pythonhosted.org/packages/d9/86/6c5f842642b88166fb21ab5218a1af47e567f684a564db77eeca2235c7d1/liquidctl-1.14.0.tar.gz"
  sha256 "a90e3f36a13adbaf2f463adf0051f30107fd3d0edecac89f46a5bd931b2b54f2"
  license "GPL-3.0-or-later"
  head "https://github.com/liquidctl/liquidctl.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a3f5fe7aa7882e86492bd878ee846acbbfd4bd4d4c1309f7ac57416f434ac829"
    sha256 cellar: :any,                 arm64_sonoma:  "a6a8e6694b8615e1b2b38c9156188ff882f53d4d485faec6248581546ed859d6"
    sha256 cellar: :any,                 arm64_ventura: "49576ad8d9c9de8468e5f4ea799e6a5fef805e6f2f8e8329e9e6610ad3a7976b"
    sha256 cellar: :any,                 sonoma:        "f4663a574207d29d9572596f1e00752227f7c29145429eacfa6c4033975f6610"
    sha256 cellar: :any,                 ventura:       "533cb471eb11fdb4b83e364a53f0d3fe0a344c079a208938143b77058fa62d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f1dd3a4be076e0773742b7daded5e8c16cb5c86b1efeb0ee29b75d67b8397cf"
  end

  depends_on "pkgconf" => :build
  depends_on "hidapi"
  depends_on "libusb"
  depends_on "pillow"
  depends_on "python@3.13"

  on_linux do
    depends_on "i2c-tools"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/d3/7a/359f4d5df2353f26172b3cc39ea32daa39af8de522205f512f458923e677/colorlog-6.9.0.tar.gz"
    sha256 "bfba54a1b93b94f54e1f4fe48395725a3d92fd2a4af702f6bd70946bdc0c6ac2"
  end

  resource "crcmod" do
    url "https://files.pythonhosted.org/packages/6b/b0/e595ce2a2527e169c3bcd6c33d2473c1918e0b7f6826a043ca1245dd4e5b/crcmod-1.7.tar.gz"
    sha256 "dc7051a0db5f2bd48665a990d3ec1cc305a466a77358ca4492826f41f283601e"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/47/72/21ccaaca6ffb06f544afd16191425025d831c2a6d318635e9c8854070f2d/hidapi-0.14.0.post4.tar.gz"
    sha256 "48fce253e526d17b663fbf9989c71c7ef7653ced5f4be65f1437c313fb3dbdf6"
  end

  resource "pyusb" do
    url "https://files.pythonhosted.org/packages/e9/63/1dead067e1d6478e1ca6ccf882ade4132f713975739b64cedccf9f33bfc7/pyusb-1.3.0.tar.gz"
    sha256 "7e6de8ef79e164ced020d8131cd17d45a3cdeefb7afdaf41d7a2cbf2378828c3"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/43/54/292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0/setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
  end

  def install
    ENV["HIDAPI_SYSTEM_HIDAPI"] = ENV["HIDAPI_WITH_LIBUSB"] = "1"
    virtualenv_install_with_resources

    man_page = buildpath/"liquidctl.8"
    # setting the is_macos register to 1 adjusts the man page for macOS
    inreplace man_page, ".nr is_macos 0", ".nr is_macos 1" if OS.mac?
    man8.install man_page

    (lib/"udev/rules.d").install Dir["extra/linux/*.rules"] if OS.linux?
  end

  test do
    system bin/"liquidctl", "list", "--verbose", "--debug"
  end
end
