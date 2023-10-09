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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e11723522beaffcdca4d1914d36d0ae5369248a6c3749edddb4e12bc656b78a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "873410ca4e9032ab9e70b04af7d04d481bbf6a142bdeb45ffe79c14d4471c827"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8a26b282fd5d8c23e7cd37c709fae5c4da19b962c3548654a6374051d5fbe87"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f0af6ac266ccd03452b59c5de0c0dc0c27bf611407318c3a0b615e9db3f7ec1"
    sha256 cellar: :any_skip_relocation, ventura:        "3b9d16690e15616243b507edb4638ee41b625dc84bc8fb8fb2de883459632118"
    sha256 cellar: :any_skip_relocation, monterey:       "d41942f1e6929d68fcb17ae927388f37eb636afdd21272d0bb92d7fb2b7372a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0bbaf895f4bc339e8e7c9f724767a0b495a90632bf1a7fc55ea08073da23edd"
  end

  depends_on "python@3.12"

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
