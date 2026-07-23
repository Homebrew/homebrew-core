class AdbEnhanced < Formula
  include Language::Python::Virtualenv

  desc "Swiss-army knife for Android testing and development"
  homepage "https://ashishb.net/tech/introducing-adb-enhanced-a-swiss-army-knife-for-android-development/"
  url "https://files.pythonhosted.org/packages/ee/c9/5271daac716345394b51a0b28c8381b06936ad797cd63006a6395451a5d6/adb_enhanced-2.10.0.tar.gz"
  sha256 "99146a68b664afdaf0e40a123daa4a0e4931dc82e995c21d9833d067945d7bd7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "598f5c643ef3e4ad485be49316051c27ffd5003d3850ae2cd5386c3add740238"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c8f9ea9c3e022f9ad80764bad40b54e2b6423bfca356531aba1f9dc80804e2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2cf005808fec965f0552f8aa398922548d614ad8209c3091d46f1e2c5f454df"
    sha256 cellar: :any_skip_relocation, sonoma:        "04e387253a57fab8da0fd0c1a45eedbdcdd657e02fac6aaf7579e9ca75b7cd32"
    sha256 cellar: :any,                 arm64_linux:   "b36d42380be384971c4912273c30150c117b09ba8ea11f13eefad156bdf8d907"
    sha256 cellar: :any,                 x86_64_linux:  "71cec49520a5c3d2d8a4bfffed7082ac784af9988bbc5e03b0005d1bb7401497"
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
