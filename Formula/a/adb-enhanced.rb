class AdbEnhanced < Formula
  include Language::Python::Virtualenv

  desc "Swiss-army knife for Android testing and development"
  homepage "https://ashishb.net/tech/introducing-adb-enhanced-a-swiss-army-knife-for-android-development/"
  url "https://files.pythonhosted.org/packages/15/98/64a9e67f5917396f5165861f7860690d0192dc3b392a70db00274d3d961a/adb_enhanced-2.12.0.tar.gz"
  sha256 "d477de8246c27e0308eeee952a5768a5844ff5c8a027d62ea40fbeb9e57e3ab4"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "483ae064e1044b73fe4076051e261e85332cb745a29f9be3561d2ebbcbee4bd2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "828e688eda04f785d63146b9a2862b08150e1905412c3ac7d7547df5bcb30667"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5411a417913761684367ee2ab03c8b9c71d5286cb29c4c7581246cd0f6e81b08"
    sha256 cellar: :any,                 arm64_linux:       "57d61f392815522628dab768f27ef72e56e02db926124bcae1ad7e00e405a5e4"
    sha256 cellar: :any,                 x86_64_linux:      "11ddbadaf4cfb6db7a8a4e760dec0f0facea60f8a7f9451c9e1d2a4473f0a8fe"
  end

  depends_on "python@3.15"

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
