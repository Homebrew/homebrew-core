class GitReview < Formula
  include Language::Python::Virtualenv

  desc "Submit git branches to gerrit for review"
  homepage "https://opendev.org/opendev/git-review"
  url "https://files.pythonhosted.org/packages/8e/5c/18f534e16b193be36d140939b79a8046e07f343b426054c084b12d59cf0b/git-review-2.3.1.tar.gz"
  sha256 "24e938136eecb6e6cbb38b5e2b034a286b70b5bb8b5a2853585c9ed23636014f"
  license "Apache-2.0"
  head "https://opendev.org/opendev/git-review.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "465665143bbad4a6e1cc00ffa3b3ddd3627ec508726f463b40d779d4e77f2a4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7df1495c0fb807fd2337b88a71766c59c35c4ff1d1d21e17f520a6d3e597379f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9010deaf20b3c78b9ba95ed5466534552549cab39d733ab351580118178ac7d3"
    sha256 cellar: :any_skip_relocation, ventura:        "e193a7e5655b097777bb43842558b0646a70e5a2ce4f6738d611c0dfc9052f92"
    sha256 cellar: :any_skip_relocation, monterey:       "0a62cd57c2a5ba7452e42035cba35275755f08ad00676bfd0cf4e23fc42cf0e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d40296f48a0f24261fc4e8dd8087807fb16d215803af8bc2fb499dc50e4875e0"
    sha256 cellar: :any_skip_relocation, catalina:       "e3b03b93811344d8b3ed75ef01b3ae386b50fa95ba776a5cc2137c36784387d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a910dfac976e4a18bb859f40e7235eecabc9deef41a706c4354dc6fd39116f03"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
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
