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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a879b38d1607fa3fdb6351a4e423fe58407a30cc4e1dbc06de2b9bfd8bf62056"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a879b38d1607fa3fdb6351a4e423fe58407a30cc4e1dbc06de2b9bfd8bf62056"
    sha256 cellar: :any_skip_relocation, monterey:       "67879764a6f7b05d9948a91cad56a18c2a85298037c2dab7c7d92d6b2aa8d534"
    sha256 cellar: :any_skip_relocation, big_sur:        "67879764a6f7b05d9948a91cad56a18c2a85298037c2dab7c7d92d6b2aa8d534"
    sha256 cellar: :any_skip_relocation, catalina:       "67879764a6f7b05d9948a91cad56a18c2a85298037c2dab7c7d92d6b2aa8d534"
    sha256 cellar: :any_skip_relocation, mojave:         "67879764a6f7b05d9948a91cad56a18c2a85298037c2dab7c7d92d6b2aa8d534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86aa4d813e08f5e3d1fb1381f80b87ce61bd62acc17f3b55cbd085cb2fafee91"
  end

  depends_on "python@3.10"

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
