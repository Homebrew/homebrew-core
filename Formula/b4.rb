class B4 < Formula
  include Language::Python::Virtualenv

  desc "Tool to help with email-based patch workflows"
  homepage "https://github.com/mricon/b4"
  url "https://github.com/mricon/b4/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "9b2b8d71f00ece3766de9bc3854dcd1b4cbc2e57f6c018406ad992f5d358b1cc"
  license "GPL-2.0-only"

  depends_on "python@3.9"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/93/1d/d9392056df6670ae2a29fcb04cfa5cee9f6fbde7311a1bb511d4115e9b7a/charset-normalizer-2.1.0.tar.gz"
    sha256 "575e708016ff3a5e3681541cb9d79312c416835686d054a23accb873b254f413"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/99/fb/e7cd35bba24295ad41abfdff30f6b4c271fd6ac70d20132fa503c3e768e0/dnspython-2.2.1.tar.gz"
    sha256 "0f7569a4a6ff151958b64304071d370daa3243d15941a7beedf0c9fe5105603e"
  end

  resource "dkimpy" do
    url "https://files.pythonhosted.org/packages/b5/33/9c60f3a34d4d7237e5c21eb73e06a34f52c3a959fa20efb705e5b0b16d01/dkimpy-1.0.5.tar.gz"
    sha256 "9a2420bf09af686736773153fca32a02ae11ecbe24b540c26104628959f91121"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "patatt" do
    url "https://files.pythonhosted.org/packages/d4/49/2006ddd45714cd6938828c3a644112a6c9615a1244cca434a1e69e265eb4/patatt-0.5.0.tar.gz"
    sha256 "3940eef7c7f708f23f85ecdd7080369dd48e7c2b1c56d86e864aaada3afd8d7a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e9/23/384d9953bb968731212dc37af87cb75a885dc48e0615bd6a303577c4dc4b/requests-2.28.0.tar.gz"
    sha256 "d568723a7ebd25875d8d1eaf5dfa068cd2fc8194b2e483d7b1f7c81918dbec6b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
      name = John Doe
      email = jdoe@example.com
    EOS
    assert_match "No thanks necessary.", shell_output("#{bin}/b4 ty 2>&1")
  end
end
