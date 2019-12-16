class Bumpversion < Formula
  include Language::Python::Virtualenv

  desc "Increase version numbers with SemVer terms"
  homepage "https://pypi.python.org/pypi/bumpversion"
  # maintained fork for the project
  # Ongoing maintenance discussion for the project, https://github.com/c4urself/bump2version/issues/86
  url "https://github.com/c4urself/bump2version/archive/v0.5.11.tar.gz"
  sha256 "f06c943b320033b3aa07958c99920474a54f1d0d76b12299fa67d59cdb17ab00"

  bottle do
    cellar :any_skip_relocation
    sha256 "12e99c24dbc2104191bfe9b21d19ce955e13fb456ab0cb3eb7f2bab9d77e2e4d" => :catalina
    sha256 "b11228119eac36538c4fcaaca83fdb83c516ea43391f9291e6935ef66db8b966" => :mojave
    sha256 "d7873c668cb0394e15652059d67466faae74a422cf3f1da275782f31b3c492e5" => :high_sierra
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_includes shell_output("script -q /dev/null #{bin}/bumpversion --help"), "bumpversion: v#{version}"
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
