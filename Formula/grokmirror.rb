class Grokmirror < Formula
  include Language::Python::Virtualenv

  desc "Framework to smartly mirror git repositories"
  homepage "https://github.com/mricon/grokmirror"
  url "https://files.pythonhosted.org/packages/c0/b1/36ae8acf7c9ec4a6afc5383e7dc0fed47596f51d8725ff367161523215bb/grokmirror-2.0.9.tar.gz"
  sha256 "d6a45827f47ee66322a96462458bf9d285eb00be22d1a9ac7156fd056a2314af"
  license "GPL-3.0-or-later"
  head "https://github.com/mricon/grokmirror.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b6363942b0ba4f4cd74100b125aeab6eb2566d9998ce5e386a40d796e8b4a9e7"
    sha256 cellar: :any_skip_relocation, big_sur:       "465221e24931ce248d415966c5d7f40501b19214b5d733865f9e8fcecba5689e"
    sha256 cellar: :any_skip_relocation, catalina:      "b4f9c7834a77322157a80a591c5dce404108c4f1d234d1bf5dfce68a5299f941"
    sha256 cellar: :any_skip_relocation, mojave:        "3b09035c635f2c77bbefd5c419ef3c878df175629ac8d6940d96c72a47f8c177"
  end

  depends_on "python@3.9"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/45/ab/74c77cf4590dfc846c101aee617f390ae679500630dd806b07f1a8e27b7b/charset-normalizer-2.0.1.tar.gz"
    sha256 "ad0da505736fc7e716a8da15bf19a985db21ac6415c26b34d2fafd3beb3d927e"
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
