class Grokmirror < Formula
  include Language::Python::Virtualenv

  desc "Framework to smartly mirror git repositories"
  homepage "https://github.com/mricon/grokmirror"
  url "https://files.pythonhosted.org/packages/b0/ef/ffad6177d84dafb7403ccaca2fef735745d5d43200167896a2068422ae89/grokmirror-2.0.11.tar.gz"
  sha256 "6bc1310dc9a0e97836201e6bb14ecbbee332b0f812b9ff345a8386cb267c908c"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/mricon/grokmirror.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ea015ecfe4f68c96b4a1f816366c27e7113f476ce2d33f18e65015dccb53366"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21f172834dac7a4425c69b21a0314fcd2098bad85718b57bbb6bd017ac74b6b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "209dcfae908dfc583ef51c67fe1e844859756fae6a168d693a9589868b68997e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c033c1e9a2d79ea0a4c2f9eba931d7131731592b6410b8b9f50b41e694e0d2b"
    sha256 cellar: :any_skip_relocation, ventura:        "aff4350097dd581cca48d15440ed6de714a9a95030b41013efc4e954e7b57a38"
    sha256 cellar: :any_skip_relocation, monterey:       "2e1bfe5ec9253f108822aa5f095cf04823058c3ee60b089370841a32a9883bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f63301274e970079a75fd4a5518ac46afb9e763e8ce210c58357ef4f9bf1f37"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir "repos/repo" do
      system "git", "init"
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "BrewTestBot@test.com"
      (testpath/"repos/repo/test").write "foo"
      system "git", "add", "test"
      system "git", "commit", "-m", "Initial commit"
      system "git", "config", "--bool", "core.bare", "true"
      mv testpath/"repos/repo/.git", testpath/"repos/repo.git"
    end
    rm_rf testpath/"repos/repo"

    system bin/"grok-manifest", "-m", testpath/"manifest.js.gz", "-t", testpath/"repos"
    system "gzip", "-d", testpath/"manifest.js.gz"
    refs = Utils.safe_popen_read("git", "--git-dir", testpath/"repos/repo.git", "show-ref")
    manifest = JSON.parse (testpath/"manifest.js").read
    assert_equal Digest::SHA1.hexdigest(refs), manifest["/repo.git"]["fingerprint"]
  end
end
