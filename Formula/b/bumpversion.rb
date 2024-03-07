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
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8074afa174f368b16b2fd1ad69dbcb6e2638ab933a164141437c2b55a173312e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7ac3256bed2acde218fb3b3140ff2e8b44b41c0857c74dcdacb93a5f07aa058"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a38fec8fdbccea9fab6a2006c427b31119a0f9371f479d8bce52f31c94e7464"
    sha256 cellar: :any_skip_relocation, sonoma:         "6547242b034e02eb54d814c4f4a94bc77aea66fbe6c8d0c4d188d6eee7ee1fea"
    sha256 cellar: :any_skip_relocation, ventura:        "bd90b97e2a19061e7bcf0bdfe209e68fb57dfb57f6151b5451a7c1eb74e25915"
    sha256 cellar: :any_skip_relocation, monterey:       "79bb3d11f64263e84fb45010f7a489bcd1cebd4330c861ca8c1bf87eb5534005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c32d99fe94c3b0433a2e2c27562fac12e9d2cf3809b329e0c285898366277acf"
  end

  depends_on "python@3.12"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

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
