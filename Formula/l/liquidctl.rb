class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https://github.com/liquidctl/liquidctl"
  url "https://files.pythonhosted.org/packages/1d/87/8b80a72696a906fde5ead01398291c4ae67353d8d445b3828af4217b7d2c/liquidctl-1.15.0.tar.gz"
  sha256 "82243acf320c2686b274c13e804e8dd56ec97eaa0a9347d4107974428fb548d1"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/liquidctl/liquidctl.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "031c352493e155ec0be429608e741d4b2c50c73b9ba15fb7d93eaeda7432b829"
    sha256 cellar: :any,                 arm64_sonoma:  "31d6591b0ba39715a5a3afef0e58ae6a60e3212d515943a35fac490e1128230e"
    sha256 cellar: :any,                 arm64_ventura: "4aa2c4495ada92c158da4daaae46588e14b645fef7ae4e1b658745eda578cb98"
    sha256 cellar: :any,                 sonoma:        "31864579d80e9dcdedbe0fcbdfefc54f347c6a3473e1d3a51033b633e258791e"
    sha256 cellar: :any,                 ventura:       "f38b71b9c2df29a00a33a2dfb564f8cf4cc6ca3bcdc602f0a9012f98020afc6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2475bdf117aabe04f0302310e18f6272aeb3e88fad4286f0c0545625cf1e70c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4af41e0d1c855dfedc050a8f5f36632b8b56dbd03286ce783206c1768ddec9db"
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
    url "https://files.pythonhosted.org/packages/00/6b/ce3727395e52b7b76dfcf0c665e37d223b680b9becc60710d4bc08b7b7cb/pyusb-1.3.1.tar.gz"
    sha256 "3af070b607467c1c164f49d5b0caabe8ac78dbed9298d703a8dbf9df4052d17e"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/9e/8b/dc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15/setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
  end

  resource "smbus" do
    on_linux do
      url "https://files.pythonhosted.org/packages/4d/5c/70e14aa4f0c586efc017e1d1aa6e2f7921eefc7602fc2d03368ff912aa91/smbus-1.1.post2.tar.gz"
      sha256 "f96d345e0aa10053a8a4917634f1dc37ba1f656fa5cace7629b71777e90855c6"
    end
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
