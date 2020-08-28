class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https://github.com/jonasmalacofilho/liquidctl"
  url "https://files.pythonhosted.org/packages/7d/92/5f6eb3f70e4de0241301927593a12e4622e89a9445f5e87bdbb19ddd5a62/liquidctl-1.4.1.tar.gz"
  sha256 "59a3bc65b3f3e71a5714224401fe6e95dfdee591a1d6f4392bc4e6d6ad72ff8d"
  license "GPL-3.0"
  head "https://github.com/jonasmalacofilho/liquidctl.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2ac17a2c76c3e9573fa25446b3163d6d12971717a5fffe398a0bfed1b96cc0cb" => :catalina
    sha256 "751f952fd1716a93878e4260706f9b704bb7131cd187426caa66092e6ea442de" => :mojave
    sha256 "a792d9ed36334e5b7a3d56b84445a630dd5cfc1124cf1da1271399368d0e7214" => :high_sierra
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
