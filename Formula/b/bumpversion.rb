class Bumpversion < Formula
  include Language::Python::Virtualenv

  desc "Increase version numbers with SemVer terms"
  homepage "https://pypi.python.org/pypi/bumpversion"
  # maintained fork for the project
  # Ongoing maintenance discussion for the project, https://github.com/c4urself/bump2version/issues/86
  url "https://files.pythonhosted.org/packages/29/2a/688aca6eeebfe8941235be53f4da780c6edee05dbbea5d7abaa3aab6fad2/bump2version-1.0.1.tar.gz"
  sha256 "762cb2bfad61f4ec8e2bdf452c7c267416f8c70dd9ecb1653fd0bbb01fa936e6"
  license "MIT"
  revision 1

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07fe68b2bd290e6567e3e4b9b6c35d11e34b3b33cfbb854da01546b1a4cb55ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c705255f579570383d66b6b8c060e4d9df8116968fcb1945b77e42b7bad78e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f0f05277d67cc7d2bc05118484f0f71aaede3643c3760c34db436e9a8693422"
    sha256 cellar: :any_skip_relocation, sonoma:         "127656f691e880532a05123ac1525cc0aa2c0af7726345684cd91aa01da05973"
    sha256 cellar: :any_skip_relocation, ventura:        "c4adb439a6a643a4bcf566ef3c8dbc36455cc29991ba637f0e298efe1f01fd44"
    sha256 cellar: :any_skip_relocation, monterey:       "895c88cb05c497f37accb186e8e2488b2475318d9de88c00ed52b76507524655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6eb5137f99b01f2ae14129dc2911e031c740c5efe6199b6e164e22d2909fee5e"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["COLUMNS"] = "80"
    command = if OS.mac?
      "script -q /dev/null #{bin}/bumpversion --help"
    else
      "script -q /dev/null -c \"#{bin}/bumpversion --help\""
    end
    assert_includes shell_output(command), "bumpversion: v#{version}"

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
