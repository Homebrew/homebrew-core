class Bumpversion < Formula
  include Language::Python::Virtualenv

  desc "Increase version numbers with SemVer terms"
  homepage "https://pypi.python.org/pypi/bumpversion"
  url "https://github.com/peritus/bumpversion/archive/v0.5.3.tar.gz"
  sha256 "97ac6efca7544853309b68efe92f113ab6bddb77ecbaefa5702a6183a30bcb33"

  bottle do
    cellar :any_skip_relocation
    sha256 "b76a4decfc09c2ff2749799e8d6801dd95d346d96031f1ab47156e75deb9ab25" => :catalina
    sha256 "d0c7bfaaa9d6b58f78cc5f33dc7a898045f4ebd13d37285c1277425a31145057" => :mojave
    sha256 "da4953ee6935686f818d2f4f83169c6a2e93613cabba3f8a1a8d26eda0dad8c7" => :high_sierra
    sha256 "24db5ac89df5d502f6a86a87699c66538e5e7f7e309f7897d6efd6bb73e64645" => :sierra
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
