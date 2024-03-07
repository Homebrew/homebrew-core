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
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "787a86002ad88eb37f057e810889538bbe4986e033ceaf85c22bb5e4ed6c290c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c383526661958aa2dc98804b3131e99830e543524ce85f8c00245da87d26ac10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "036936d79f013444d33887f5c3f2043b85abfde433382a79d5d6e2c9095515c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ba06250e355ad8818092c253b43c55d246f6a7861f21a6d99d70166754b7f6b"
    sha256 cellar: :any_skip_relocation, ventura:        "3adc8be851557163aeffed324bdb4ae02f5e07383507f8d0da2c133c2f9379d3"
    sha256 cellar: :any_skip_relocation, monterey:       "56a51188af1907f43fd58f29d7a9baf769904682e8acae757b793e1f6195dec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc3f7fedbb7e0d4ff8d4fc09b0bc91a3660f5fd72ec33b6d9bc56a1f179b104e"
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
