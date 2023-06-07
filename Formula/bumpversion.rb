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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d744c60c727965e1457efbdb52a1cf1523ce9c29b846f73105a735f19ed31b57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d744c60c727965e1457efbdb52a1cf1523ce9c29b846f73105a735f19ed31b57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d744c60c727965e1457efbdb52a1cf1523ce9c29b846f73105a735f19ed31b57"
    sha256 cellar: :any_skip_relocation, ventura:        "ed3afb6ecd34d1b4e898877d309e6652a3ddfcc7a145322477a7f58d5d0bd6f2"
    sha256 cellar: :any_skip_relocation, monterey:       "ed3afb6ecd34d1b4e898877d309e6652a3ddfcc7a145322477a7f58d5d0bd6f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed3afb6ecd34d1b4e898877d309e6652a3ddfcc7a145322477a7f58d5d0bd6f2"
    sha256 cellar: :any_skip_relocation, catalina:       "ed3afb6ecd34d1b4e898877d309e6652a3ddfcc7a145322477a7f58d5d0bd6f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a45afe9a5c2eb4f45044b2e7661f1f95d70e1f6d0518a4ffe0e62c205de364d2"
  end

  depends_on "python@3.11"

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
