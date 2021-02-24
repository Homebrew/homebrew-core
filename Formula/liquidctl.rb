class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https://github.com/jonasmalacofilho/liquidctl"
  url "https://files.pythonhosted.org/packages/2b/08/7e2ef5744d6c56a5ceb79fdc1bf280fff53111859a554f41ecb56f80e77c/liquidctl-1.5.1.tar.gz"
  sha256 "9480e2dfbb0406fa8d57601a43a0f7c7573de1f5f24920b0e4000786ed236a8b"
  license "GPL-3.0-or-later"
  head "https://github.com/jonasmalacofilho/liquidctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fc9a4ef8e0885a8ae2f9bede87dcbfff051361be97aba7d8ca1bf41cb421c368"
    sha256 cellar: :any_skip_relocation, big_sur:       "3618276b06bacdabe57f01680b21bbfb92378810ddac5c0386b84b4a9e7153c0"
    sha256 cellar: :any_skip_relocation, catalina:      "e2ef12a11773067a7629d1fd8f6895b1333cb6982823cf665caa60a5e777f07d"
    sha256 cellar: :any_skip_relocation, mojave:        "0093e4e5ab94017f3d9267a3a0ade3fab7261e803ef62e27851dce25d921b83a"
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
