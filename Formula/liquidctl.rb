class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https://github.com/jonasmalacofilho/liquidctl"
  url "https://files.pythonhosted.org/packages/source/l/liquidctl/liquidctl-1.3.3.tar.gz"
  sha256 "d13180867e07420c5890fe1110e8f45fe343794549a9ed7d5e8e76663bc10c24"
  revision 1
  head "https://github.com/jonasmalacofilho/liquidctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a53999bfff6851c082316fff388e7c234a9da0ea5475f7222bca1c92e13233c0" => :catalina
    sha256 "a91c7c1f530fd905bbf20470f1b1251e15c3cd16ccc796633f5c6eef6071b34b" => :mojave
    sha256 "6671f3b533c6beaa100dee5a3369769a8550a92456dc9b463b497712d8725534" => :high_sierra
  end

  depends_on "libusb"
  depends_on "python@3.8"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/7c/a0/d5ca6f191c8860a4769ba19448d2b2d6b3e2ca2c30aa61bb96a3f6bd25ba/hidapi-0.9.0.post2.tar.gz"
    sha256 "a71dd3c153cb6bb2b73d2612b5ab262830d78c6428f33f0c06818749e64c9320"
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
