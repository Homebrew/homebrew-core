class AdbEnhanced < Formula
  include Language::Python::Virtualenv

  desc "Swiss-army knife for Android testing and development"
  homepage "https://ashishb.net/tech/introducing-adb-enhanced-a-swiss-army-knife-for-android-development/"
  url "https://files.pythonhosted.org/packages/4b/4f/4dcfc75d66d3c9c8c5cb5fc4c41b371074a7a646f64e271fd847947b2278/adb_enhanced-2.11.0.tar.gz"
  sha256 "d93693f8156d4a86233c0b9a23e63efa54501556b783c2d87482c467ac1837d6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d00176927b96d547a6579739834f8925e3ab4132eb898631f996bbf8c26dcdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f79edf6fa8a861ec1f19192e5f1d715ac8ad36ada265e6f49c0345b660635d35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f284de36dc8dcd26df93a18b13d231ce59f9c66a2027fd6f5927a33112d87910"
    sha256 cellar: :any_skip_relocation, sonoma:        "d57ab3c3312007e97c629899ba51f2ddd8bbcb9d90269943521856f6abea04df"
    sha256 cellar: :any,                 arm64_linux:   "5af0f291acf2fd43f30390911da70e9431b2346b7ad0464a9f44dd040fea6659"
    sha256 cellar: :any,                 x86_64_linux:  "46ef7a3f5b7ef7b11bbdcd839c6bd5e3bec82436309203abe61145890e530898"
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
