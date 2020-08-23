class Bumpversion < Formula
  include Language::Python::Virtualenv

  desc "Increase version numbers with SemVer terms"
  homepage "https://pypi.python.org/pypi/bumpversion"
  # maintained fork for the project
  # Ongoing maintenance discussion for the project, https://github.com/c4urself/bump2version/issues/86
  url "https://github.com/c4urself/bump2version/archive/v1.0.0.tar.gz"
  sha256 "06a7cb0fb7155b9283c4d10180e477f658754595b4dedb249f1e143e899d0e6c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a379a5aa089128d51f39a585e3465520b4a109a7b98e0237dc5b4478ce050001" => :catalina
    sha256 "dea282fd874f598a1099885ee821f1f45662844724e9650362848de637e421d0" => :mojave
    sha256 "0ef3a9a86d8504dc510d4ccff21d71b832335abb7d7c739b5e514ef654b3900c" => :high_sierra
  end

  depends_on "python@3.8"

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
