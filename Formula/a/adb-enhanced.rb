class AdbEnhanced < Formula
  include Language::Python::Virtualenv

  desc "Swiss-army knife for Android testing and development"
  homepage "https://ashishb.net/tech/introducing-adb-enhanced-a-swiss-army-knife-for-android-development/"
  url "https://files.pythonhosted.org/packages/b6/c9/11f95027ba0bf13938abe329809154e6342181380d3530f26018325b79e7/adb_enhanced-2.7.1.tar.gz"
  sha256 "2f09d6edc663fd7fe34b9cb65232e5b85238c7c53bd8284b826fe62fbb039ae1"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79e4ba0ad8eff1c52d4f630af4039231824eae00171c113072768f53e7f60482"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8deefa2050df50026ff63acc7cd8d3e6addb5bf9ac067b71b830ceac04eff624"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "646209bc549d1c4fde9b65f8559be8de43251297ebd904449cd4db47a849e353"
    sha256 cellar: :any_skip_relocation, sonoma:        "7038c821594759b71f5333f03752e7178700970629b04d97b0af8f039b4db89a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53ece69f192371adbcd68db594082cca95b8a65945e45c5ef242924924a9fcc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a12e4cc653134bef9073855829d87e9931d927325e413b0340a5a3d44ef4d96"
  end

  depends_on "python@3.14"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

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
