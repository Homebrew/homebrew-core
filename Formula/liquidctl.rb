class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https://github.com/jonasmalacofilho/liquidctl"
  url "https://files.pythonhosted.org/packages/ea/b9/10ab636257e1dcaca0e268e8c44725fe107b1556d5343fba5a51cdc59f5d/liquidctl-1.5.0.tar.gz"
  sha256 "762561a8b491aa98f0ccbbab4f9770813a82cc7fd776fa4c21873b994d63e892"
  license "GPL-3.0-or-later"
  head "https://github.com/jonasmalacofilho/liquidctl.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "913066333212aff43c0a6ae028ec28326c8b4bae1b15f88cd5e1a2db552b30d0"
    sha256 cellar: :any_skip_relocation, big_sur:       "4c7ddd2507ad0fe438456f3c3c0c84aa542b82813127a88a417e2dfcbc7dd470"
    sha256 cellar: :any_skip_relocation, catalina:      "e7b2567046ea9510da8dcb3021912960c2dd704d3afb7df562cbf4c1818c3334"
    sha256 cellar: :any_skip_relocation, mojave:        "9bae5cf49538eec54d001a3125a9e0d8995b19ab556040e96a9e3f8c93cc0975"
  end

  depends_on "libusb"
  depends_on "python@3.9"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/99/9b/5c41756461308a5b2d8dcbcd6eaa2f1c1bc60f0a6aa743b58cab756a92e1/hidapi-0.10.1.tar.gz"
    sha256 "a1170b18050bc57fae3840a51084e8252fd319c0fc6043d68c8501deb0e25846"
  end

  resource "pyusb" do
    url "https://files.pythonhosted.org/packages/b9/8d/25c4e446a07e918eb39b5af25c4a83a89db95ae44e4ed5a46c3c53b0a4d6/pyusb-1.1.1.tar.gz"
    sha256 "7d449ad916ce58aff60b89aae0b65ac130f289c24d6a5b7b317742eccffafc38"
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
