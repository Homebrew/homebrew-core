class AdbEnhanced < Formula
  include Language::Python::Virtualenv

  desc "Swiss-army knife for Android testing and development"
  homepage "https://ashishb.net/tech/introducing-adb-enhanced-a-swiss-army-knife-for-android-development/"
  url "https://files.pythonhosted.org/packages/6e/97/03a20670350acfba7f8f65bba41123dbebca48a81600563181647c5bfdd0/adb_enhanced-2.9.0.tar.gz"
  sha256 "ea81e5ab640c1a129e4362156ef5ff5b37bb62c1145acd77e259f8c582ea262b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2809efcb22479d95a018af5c386e206fbd4e48acdb26bd6b00671c8c9aeea1ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "495a8231c7f6a7d734bf1cc2cf809dbdb63e056415c55201e1aa86d2e026429a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06f941031ce453369ac43e745c8bfaf495bd3c49cc32d21613717f3fb3e6089e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1445fb053288c04206e7ac49057b3d773a0fc0c5e7ea9b43cd69c407542e09a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d345e0905f33ffccf3ac629dd83efdde2a72c7aaf8a23cc4437ad01a86b4a895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6027ff5d7de7244c1b9e90d25b3a60e644bc081d1419e218541f4690b66220a"
  end

  depends_on "python@3.14"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  # Although the virtualenv_install_with_resources uses the package resources listed above,
  # pip still needs to fetch the project's chosen build system via the network.
  deny_network_access! [:postinstall, :test]

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/adbe --version")
    # ADB is not intentionally supplied
    # There are multiple ways to install it and we don't want dictate
    # one particular way to the end user
    assert_match(/(not found)|(No attached Android device found)/, shell_output("#{bin}/adbe devices", 1))
  end
end
