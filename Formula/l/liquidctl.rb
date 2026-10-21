class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https://github.com/liquidctl/liquidctl"
  url "https://files.pythonhosted.org/packages/7f/9c/11f37716eeeccc72a781c80e76021a33cafa35578627263199ea62b2eb2d/liquidctl-1.16.0.tar.gz"
  sha256 "b631a9f9c17980304c482ba72599b4089cc168d8c2edfdf65b0daa85cc614f8f"
  license "GPL-3.0-or-later"
  head "https://github.com/liquidctl/liquidctl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "7886085d15016961c2a157ed503a6818cfdff205c39d472df15506d625d8393b"
    sha256 cellar: :any, arm64_tahoe:       "5067c0a254a0c32fcca6eb8cdbc84b2eacb56d8e1ed16df61e781358bc70e46a"
    sha256 cellar: :any, arm64_sequoia:     "1cde528af75a5f2bd0395638d2e089eb55843b92d9f2ce4fde74885d92f76388"
    sha256 cellar: :any, arm64_linux:       "da40e83a7be6bd0b961458c62efe6c45933c5453fdbf89703f0cb02bff5c26c5"
    sha256 cellar: :any, x86_64_linux:      "b42ced5162fe6fe8567775b753c223e1a2280d37a03848cd8b823bbcadce8175"
  end

  depends_on "pkgconf" => :build
  depends_on "hidapi"
  depends_on "libusb"
  depends_on "pillow" => :no_linkage
  depends_on "python@3.15"

  on_linux do
    depends_on "i2c-tools"
  end

  pypi_packages exclude_packages: "pillow"

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/8c/55/ba79756cb90c8d69d599d57785398ac87bba7b19c80e87f4e8a562197c93/colorlog-6.12.0.tar.gz"
    sha256 "2a7924c1dadf18b22a0eb8b06d1c7b01d5341707ec1641eb6fcc4fde0c3e8e5f"
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
    url "https://files.pythonhosted.org/packages/74/f6/caad9ed701fbb9223eb9e0b41a5514390769b4cb3084a2704ab69e9df0fe/hidapi-0.15.0.tar.gz"
    sha256 "ecbc265cbe8b7b88755f421e0ba25f084091ec550c2b90ff9e8ddd4fcd540311"
  end

  resource "pyusb" do
    url "https://files.pythonhosted.org/packages/00/6b/ce3727395e52b7b76dfcf0c665e37d223b680b9becc60710d4bc08b7b7cb/pyusb-1.3.1.tar.gz"
    sha256 "3af070b607467c1c164f49d5b0caabe8ac78dbed9298d703a8dbf9df4052d17e"
  end

  resource "smbus" do
    on_linux do
      url "https://files.pythonhosted.org/packages/4d/5c/70e14aa4f0c586efc017e1d1aa6e2f7921eefc7602fc2d03368ff912aa91/smbus-1.1.post2.tar.gz"
      sha256 "f96d345e0aa10053a8a4917634f1dc37ba1f656fa5cace7629b71777e90855c6"
    end
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
