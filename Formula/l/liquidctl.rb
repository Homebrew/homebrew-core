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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "63b4ac7a552c00a37b4b626b3163a3e7c275dba5ad63f3f707b744c6901a5632"
    sha256 cellar: :any,                 arm64_sequoia: "1a5ccb7a04dfda0fe3c79d6f34486b9fb4c69e96663b1fcac7679aae7d7974ac"
    sha256 cellar: :any,                 arm64_sonoma:  "39589c229c94d548a9b8fba0fe087994a2f2590a7b35401e24fbddd3b53e95b1"
    sha256 cellar: :any,                 sonoma:        "32805c65afba7042eee53fdd22452ac8f598f285189cfd2df1f188d2257fc6a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c69e12cbe513510bff71ed2a8c2f0ec958c0d9ea4d4189ead137eed35361621d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf919448f0f83ef3ce22aa46b4b3d667fe82317311d00bf9c5d4057c5bfd8e84"
  end

  depends_on "pkgconf" => :build
  depends_on "hidapi"
  depends_on "libusb"
  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"

  on_linux do
    depends_on "i2c-tools"
  end

  pypi_packages exclude_packages: "pillow"

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
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
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
