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
    sha256 "87490444b85667f4bd90ea644a9ab798377bb7a900ad686e853ebc7909eb1c4d" => :catalina
    sha256 "12c6314db620e3983e9d94cea879ba6ccb772c4a492de190068dce2a6a30c3ec" => :mojave
    sha256 "c412d7297dcf8bc5b2061b06b3eec738300f801ba57212568953260b038999bb" => :high_sierra
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
