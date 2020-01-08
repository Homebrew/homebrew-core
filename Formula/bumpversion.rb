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
    rebuild 1
    sha256 "154d61b2bee73203d79d39aa3a111dc394f4e2d8359a8b7e8e58349ebd07d4a2" => :catalina
    sha256 "586064c90434be74c2750a75881e1461384d832f782db1c06797beb459d68b76" => :mojave
    sha256 "5b40851a4fa852ef9b58c379aeba9ace20f6c3132c1caad41ce43307e79b68d9" => :high_sierra
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
