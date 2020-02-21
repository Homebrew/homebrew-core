class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https://github.com/jonasmalacofilho/liquidctl"
  url "https://files.pythonhosted.org/packages/source/l/liquidctl/liquidctl-1.3.3.tar.gz"
  sha256 "d13180867e07420c5890fe1110e8f45fe343794549a9ed7d5e8e76663bc10c24"

  head "https://github.com/jonasmalacofilho/liquidctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e3fc1c2aa8b9afa50f27023117ff9d9ec6db663047747995213f1ce790279e5" => :catalina
    sha256 "446e9b6d26a47ba1ae251f6b6223a68f431f31c09cebe15a5e03917aa3687733" => :mojave
    sha256 "b98fb1a4ccac80207a325844aa8c10c0bf0dde749157dcf4663ad17c1b73693b" => :high_sierra
  end

  depends_on "libusb"
  depends_on "python"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/source/h/hidapi/hidapi-0.7.99.post21.tar.gz"
    sha256 "e0be1aa6566979266a8fc845ab0e18613f4918cf2c977fe67050f5dc7e2a9a97"
  end

  resource "pyusb" do
    url "https://files.pythonhosted.org/packages/source/p/pyusb/pyusb-1.0.2.tar.gz"
    sha256 "4e9b72cc4a4205ca64fbf1f3fff39a335512166c151ad103e55c8223ac147362"
  end

  def install
    # customize liquidctl --version
    ENV["DIST_NAME"] = "homebrew"
    ENV["DIST_PACKAGE"] = "liquidctl #{version}"

    virtualenv_install_with_resources

    man_page = buildpath/"liquidctl.8"
    # setting the is_macos register to 1 adjusts the man page for macOS
    inreplace man_page, ".nr is_macos 0", ".nr is_macos 1"
    man.mkpath
    man8.install man_page
  end

  test do
    shell_output "#{bin}/liquidctl list --verbose --debug"
  end
end
