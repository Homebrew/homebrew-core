class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https://github.com/liquidctl/liquidctl"
  url "https://files.pythonhosted.org/packages/99/d9/15bfe9dc11f2910b7483693b0bab16a382e5ad16cee657ff8133b7cae56d/liquidctl-1.13.0.tar.gz"
  sha256 "ee17241689c0bf3de43cf4d97822e344f5b57513d16dd160e37fa0e389a158c7"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/liquidctl/liquidctl.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5b7d116b57b269eadd7006affac38a95761f8b8773aa18877bfb27378bec8467"
    sha256 cellar: :any,                 arm64_sonoma:  "1a4301c9452fbb366a43e086d77bfafb140af1fe4a6256bee0171803cdcf5700"
    sha256 cellar: :any,                 arm64_ventura: "baf3ad92ea880d182f53ee80fd8cabd47a3ba8a4ef6f78557584a3f1eb1cf243"
    sha256 cellar: :any,                 sonoma:        "bf35060fb1ad3e14d28affbb22c42680db0322103944e10f1adb8bde29b19c68"
    sha256 cellar: :any,                 ventura:       "73e72321380e52953bc9d0564a74aeed8f7cc01e589ed4a6b3b613b31d13ce1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daeeeb0e6b98a1275460bce5cae4994c1c74307c2447dff786da1c744c4d9ce6"
  end

  depends_on "pkg-config" => :build
  depends_on "hidapi"
  depends_on "libusb"
  depends_on "pillow"
  depends_on "python@3.13"

  on_linux do
    depends_on "i2c-tools"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/db/38/2992ff192eaa7dd5a793f8b6570d6bbe887c4fbbf7e72702eb0a693a01c8/colorlog-6.8.2.tar.gz"
    sha256 "3e3e079a41feb5a1b64f978b5ea4f46040a94f11f0e8bbb8261e3dbbeca64d44"
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
    url "https://files.pythonhosted.org/packages/bf/6f/90c536b020a8e860f047a2839830a1ade3e1490e67336ecf489b4856eb7b/hidapi-0.14.0.post2.tar.gz"
    sha256 "6c0e97ba6b059a309d51b495a8f0d5efbcea8756b640d98b6f6bb9fdef2458ac"
  end

  resource "pyusb" do
    url "https://files.pythonhosted.org/packages/d9/6e/433a5614132576289b8643fe598dd5d51b16e130fd591564be952e15bb45/pyusb-1.2.1.tar.gz"
    sha256 "a4cc7404a203144754164b8b40994e2849fde1cfff06b08492f12fff9d9de7b9"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
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
