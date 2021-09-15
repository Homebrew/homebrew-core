class Bumpversion < Formula
  include Language::Python::Virtualenv

  desc "Increase version numbers with SemVer terms"
  homepage "https://pypi.python.org/pypi/bumpversion"
  # maintained fork for the project
  # Ongoing maintenance discussion for the project, https://github.com/c4urself/bump2version/issues/86
  url "https://files.pythonhosted.org/packages/29/2a/688aca6eeebfe8941235be53f4da780c6edee05dbbea5d7abaa3aab6fad2/bump2version-1.0.1.tar.gz"
  sha256 "762cb2bfad61f4ec8e2bdf452c7c267416f8c70dd9ecb1653fd0bbb01fa936e6"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1d69dd65cfe24eae5ab087a4d8907f1e7ac8437911d31c34b5881700fc5ce69e"
    sha256 cellar: :any_skip_relocation, big_sur:       "9fefa3665413e3241a1c796d8363abf903c9c157177dba7277f5dc8d9532a327"
    sha256 cellar: :any_skip_relocation, catalina:      "a56efe7440a9495e9b4f2d6ef82a2f56e088db459aa680c3ab5368b1b47c17db"
    sha256 cellar: :any_skip_relocation, mojave:        "18141d47aa00efccaa7e0de803a190abe09549d485e82db5f7af57a40b79aa3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98bc2e4d4aab87c22a59e3aad2778e18a7b69810de3ac7bb94053b07e3eb6ae6"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["COLUMNS"] = "80"
    on_macos do
      assert_includes shell_output("script -q /dev/null #{bin}/bumpversion --help"), "bumpversion: v#{version}"
    end
    on_linux do
      assert_includes shell_output("script -q /dev/null -c \"#{bin}/bumpversion --help\""), "bumpversion: v#{version}"
    end
    version_file = testpath/"VERSION"
    version_file.write "0.0.0"
    system bin/"bumpversion", "--current-version", "0.0.0", "minor", version_file
    assert_match "0.1.0", version_file.read
    system bin/"bumpversion", "--current-version", "0.1.0", "patch", version_file
    assert_match "0.1.1", version_file.read
    system bin/"bumpversion", "--current-version", "0.1.1", "major", version_file
    assert_match "1.0.0", version_file.read
  end
end
