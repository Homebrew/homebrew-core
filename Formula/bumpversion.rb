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
    cellar :any_skip_relocation
    sha256 "d8b819a451310e2c12c43f7fc33b7c59b9a8dbeb9836729357c97b4faf8a991d" => :big_sur
    sha256 "029b3b705fe229e3f485ce386a520f926bfb905d79bc470f3d9f89dd62484c1d" => :arm64_big_sur
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
