class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https://github.com/jonasmalacofilho/liquidctl"
  url "https://files.pythonhosted.org/packages/3c/98/df8a6481d5b7dee73c12327acb0ec18364275ba85b1e6d3faa29c45463a9/liquidctl-1.7.0.tar.gz"
  sha256 "053675aca9ba9a3c14d8ef24d1a2e75c592c55a1b8ba494447bc13d3ae523d6f"
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

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/07/d4/ac5127f7d7e022caf740b9f624e5b9fe9a69fefc0f4f9c047b1e9298c87a/colorlog-5.0.1.tar.gz"
    sha256 "f17c013a06962b02f4449ee07cfdbe6b287df29efc2c9a1515b4a376f4e588ea"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/99/9b/5c41756461308a5b2d8dcbcd6eaa2f1c1bc60f0a6aa743b58cab756a92e1/hidapi-0.10.1.tar.gz"
    sha256 "a1170b18050bc57fae3840a51084e8252fd319c0fc6043d68c8501deb0e25846"
  end

  resource "pyusb" do
    url "https://files.pythonhosted.org/packages/b8/5a/d5d54813eb18ca8d0a03c51c5248c8564d422b4c35a9b7b0fd1b4f1b8154/pyusb-1.2.0.tar.gz"
    sha256 "d68597d2cf7df766bdf816b1a337b72ab8233c19825e170ae18714f16b838cbc"
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
