class Bumpversion < Formula
  include Language::Python::Virtualenv

  desc "Increase version numbers with SemVer terms"
  homepage "https://pypi.python.org/pypi/bumpversion"
  # maintained fork for the project
  # Ongoing maintenance discussion for the project, https://github.com/c4urself/bump2version/issues/86
  url "https://github.com/c4urself/bump2version/archive/v1.0.1.tar.gz"
  sha256 "b0864d58b0ef231f99fef85ee028633d9366557a748e29cd92df0aa94f83f5fc"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "98faab4d2a8683aeae0d70544ddd975fe3bb67754faa5723ef085555d103990f" => :catalina
    sha256 "7e216796b73d0fd1903ee89b84bbaa259e64aafc3db6596dbb5e6009b7870d44" => :mojave
    sha256 "15fa88250157b9773f20b7645410778be0afb63855eabe38bc572f52dafb31b6" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["COLUMNS"] = "80"
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
