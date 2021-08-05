class Grokmirror < Formula
  include Language::Python::Virtualenv

  desc "Framework to smartly mirror git repositories"
  homepage "https://github.com/mricon/grokmirror"
  url "https://files.pythonhosted.org/packages/10/1f/cf5a4d8c45dfb0dd0c7e362681c0c68174104370847f116af1a3cb842234/grokmirror-2.0.10.tar.gz"
  sha256 "43acdb4d84438a9954df230e1c43c1ecff6b7e2f7fb1ed5fc5721ca53ea0768a"
  license "GPL-3.0-or-later"
  head "https://github.com/mricon/grokmirror.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c4b2e1aff367555f7b7a349aaa323972a089ea1a8c0337239f186710732e9a3d"
    sha256 cellar: :any_skip_relocation, big_sur:       "8031f6c7437aeae82e44fd5178f608a0b75c7d29c3fa51968d1c48384b660b84"
    sha256 cellar: :any_skip_relocation, catalina:      "8031f6c7437aeae82e44fd5178f608a0b75c7d29c3fa51968d1c48384b660b84"
    sha256 cellar: :any_skip_relocation, mojave:        "8031f6c7437aeae82e44fd5178f608a0b75c7d29c3fa51968d1c48384b660b84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac5d8c10592869e44cd19e39337c330e6c74419a9b553354b44dde3460b691df"
  end

  depends_on "python@3.9"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/37/fd/05a04d7e14548474d30d90ad0db5d90ee2ba55cd967511a354cf88b534f1/charset-normalizer-2.0.3.tar.gz"
    sha256 "c46c3ace2d744cfbdebceaa3c19ae691f53ae621b39fd7570f59d14fb7f2fd12"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/38/4c4d00ddfa48abe616d7e572e02a04273603db446975ab46bbcd36552005/idna-3.2.tar.gz"
    sha256 "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
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
