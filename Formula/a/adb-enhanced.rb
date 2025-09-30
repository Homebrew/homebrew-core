class AdbEnhanced < Formula
  include Language::Python::Virtualenv

  desc "Swiss-army knife for Android testing and development"
  homepage "https://ashishb.net/tech/introducing-adb-enhanced-a-swiss-army-knife-for-android-development/"
  url "https://files.pythonhosted.org/packages/b6/c9/11f95027ba0bf13938abe329809154e6342181380d3530f26018325b79e7/adb_enhanced-2.7.1.tar.gz"
  sha256 "2f09d6edc663fd7fe34b9cb65232e5b85238c7c53bd8284b826fe62fbb039ae1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "081f2ef20fd6be3e1bb0d8840a3e57de4f76dacaef8b3c58a147d6b4a3220c63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dba59fec41a9d6f7220a78fcbf1a2880697b8356e9b2a0c0cf871e5334c47417"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41baf08c68351b847a54f16537c057461c93f83984cf46568cb94229405463f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "744e13c7a1058febdd876756cc7b59a036bfaf6bcbf4737fbbe1bf749408a4b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d1b1d970eac95076769eedf0768d8c57e1d7cded746339c3e080286a47c236d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa25013ba903c83b84e26cfd7011d9121ff37dda6c5a69287401c1dece74ff04"
  end

  depends_on "python@3.13"

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
