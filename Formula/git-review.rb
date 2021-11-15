class GitReview < Formula
  include Language::Python::Virtualenv

  desc "Submit git branches to gerrit for review"
  homepage "https://opendev.org/opendev/git-review"
  url "https://files.pythonhosted.org/packages/52/32/314cdb83186d43661a36d3e49390f818bce4e878b90a0bc980a3c70252bb/git-review-2.1.0.tar.gz"
  sha256 "3a6c775645b1fa8c40c49fbfce6f8d7e225a1e797a0aa92912607b1d97e61ed6"
  license "Apache-2.0"
  revision 1
  head "https://opendev.org/opendev/git-review.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "849525c398470ac641da1061d8e3e115b661f5d25b2f652b4a921e3e9a8509cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "849525c398470ac641da1061d8e3e115b661f5d25b2f652b4a921e3e9a8509cc"
    sha256 cellar: :any_skip_relocation, monterey:       "044c579945a6fc3ec04f2d55f85fe983cb7a74851ac0484f6f58f08a1d678e32"
    sha256 cellar: :any_skip_relocation, big_sur:        "044c579945a6fc3ec04f2d55f85fe983cb7a74851ac0484f6f58f08a1d678e32"
    sha256 cellar: :any_skip_relocation, catalina:       "044c579945a6fc3ec04f2d55f85fe983cb7a74851ac0484f6f58f08a1d678e32"
    sha256 cellar: :any_skip_relocation, mojave:         "044c579945a6fc3ec04f2d55f85fe983cb7a74851ac0484f6f58f08a1d678e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cc359ba6a02c07243950ee6fd590272e7a8aba03a44fb28b88324f6377f4772"
  end

  depends_on "python@3.10"

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
    url "https://files.pythonhosted.org/packages/cb/cf/871177f1fc795c6c10787bc0e1f27bb6cf7b81dbde399fd35860472cecbc/urllib3-1.26.4.tar.gz"
    sha256 "e7b021f7241115872f92f43c6508082facffbd1c048e3c6e2bb9c2a157e28937"
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
