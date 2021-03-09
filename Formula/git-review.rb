class GitReview < Formula
  include Language::Python::Virtualenv

  desc "Submit git branches to gerrit for review"
  homepage "https://opendev.org/opendev/git-review"
  url "https://files.pythonhosted.org/packages/54/36/445652deaa5e19a58e5512bdc8c5a37ccc9673cb205c7e06ff776cb8b228/git-review-2.0.0.tar.gz"
  sha256 "6e6c86b61334526c5c0f200fdf61957310b0c32208339a38c890db7fe0de5452"
  license "Apache-2.0"
  head "https://opendev.org/opendev/git-review.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9debd3ad5a89634c1bca857954d4779f373bc99399c8db0cff255e311fbebb4e"
    sha256 cellar: :any_skip_relocation, big_sur:       "c58c18e8d55c19ecb4929a18fd312289f50e58bb9b45a63a5fbd7fd29abf31f6"
    sha256 cellar: :any_skip_relocation, catalina:      "ec3f9cba6b5196e3c0637e557c7412808f35c8707f73b88112938e9da6b0e1fb"
    sha256 cellar: :any_skip_relocation, mojave:        "ca833fbdf9790089a597b8e52ecccca721b518fd6ac6ca09ae63521d5e1a3ebf"
  end

  depends_on "python@3.9"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/d7/8d/7ee68c6b48e1ec8d41198f694ecdc15f7596356f2ff8e6b1420300cf5db3/urllib3-1.26.3.tar.gz"
    sha256 "de3eedaad74a2683334e282005cd8d7f22f4d55fa690a2a1020a416cb0a47e73"
  end

  def install
    virtualenv_install_with_resources
    man1.install gzip("git-review.1")
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "git", "remote", "add", "gerrit", "https://github.com/Homebrew/brew.sh"
    (testpath/".git/hooks/commit-msg").write "# empty - make git-review happy"
    (testpath/"foo").write "test file"
    system "git", "add", "foo"
    system "git", "commit", "-m", "test"
    system "#{bin}/git-review", "--dry-run"
  end
end
