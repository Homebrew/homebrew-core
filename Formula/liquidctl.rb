class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https://github.com/jonasmalacofilho/liquidctl"
  url "https://files.pythonhosted.org/packages/8b/aa/fe1e38a2092a674e80def5dcde1d54ae41da7b9424d143f35b1179e9faa1/liquidctl-1.6.1.tar.gz"
  sha256 "e3b6aa5ae55204f8d9a8813105269df7dc8f80087670e3eac88b722949b3843f"
  license "GPL-3.0-or-later"
  head "https://github.com/jonasmalacofilho/liquidctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "756b2b32a0e6440ef2fb75ac6273c1211960fb132d4a0afc062ef4c41fea5411"
    sha256 cellar: :any_skip_relocation, big_sur:       "63068884b025d541321ad4e7a35e06547b700a1b687fb0e81a347fdf20759f0e"
    sha256 cellar: :any_skip_relocation, catalina:      "8b736b2048c0732d0777238ba4a34135906a3d50c9a5018dc292fea77857ab59"
    sha256 cellar: :any_skip_relocation, mojave:        "cd4a4c709d22b120df4c2ef1206ebd84cbc1c268fb20f0e5bccee59f7a9c3161"
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
