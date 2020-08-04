class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https://github.com/jonasmalacofilho/liquidctl"
  url "https://files.pythonhosted.org/packages/43/37/7d30f2ba5eade8715c8981d552bcc6b67a039426fc32aa2722b5af321e67/liquidctl-1.4.0.tar.gz"
  sha256 "b35e6f297e67f9e145794bb57b88c626ef2bfd97e7fbb5b098f3dbf9ae11213e"
  license "GPL-3.0"
  head "https://github.com/jonasmalacofilho/liquidctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb1825861905de403f759203b015a7e3fca7ba814e0a364b93426f21ff28553b" => :catalina
    sha256 "89f6b2caa75d40bb321783eea887c1298a6467cdd517cbe2f9ad14c4b6acfd15" => :mojave
    sha256 "af6b3aa6900598d9524a42dc572ad0c28bc6a05f10e67b5459ec67c560c42d88" => :high_sierra
  end

  depends_on "libusb"
  depends_on "python@3.8"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/ee/e9/b2ec08690c280a0eaa4777bf829db6b5d269903d4e8e9ce82f079c837d5a/hidapi-0.9.0.post3.tar.gz"
    sha256 "5a2442928f17ba742d9c53073f48b152051c5747d758d2fefd937543da5ab2e5"
  end

  resource "pyusb" do
    url "https://files.pythonhosted.org/packages/5f/34/2095e821c01225377dda4ebdbd53d8316d6abb243c9bee43d3888fa91dd6/pyusb-1.0.2.tar.gz"
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
