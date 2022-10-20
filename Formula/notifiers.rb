class Notifiers < Formula
  include Language::Python::Virtualenv

  desc "Easy way to send notifications"
  homepage "https://pypi.org/project/notifiers/"
  url "https://files.pythonhosted.org/packages/54/fc/aa5de032cc8d9ee41ceba7bbea98e2ed7090d7d95465dfe0179eb937146f/notifiers-1.3.3.tar.gz"
  sha256 "9fd8d95ab1ebcd3852423755aa90cbb0f72a805ca77af0d8c9ad7af445f58399"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae0751eda811803cff41beeae5e1a4e1975c468b43c84292d8a2a4704472da66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c65011533dd5eb881d2e62e84e34e68942c96e304d7159e150556b779d3cb501"
    sha256 cellar: :any_skip_relocation, monterey:       "14479fdc7c153d7f59c15d8a5f39882f74b0e907efedb0475828b3fde62b2f6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd51cb92313fd6508bd81724ea6041a92e9dd9e593efc69db39ea60875f2dfa9"
    sha256 cellar: :any_skip_relocation, catalina:       "8c1aaa09c061f4783a65bedd43af0f4ce5a57e4ff67a7bcbc03b938fbc469a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e36373228406d86243c04c559b1ccc442c53c1a883c0ce67ff49c3a8c3e8ca0f"
  end

  depends_on "jsonschema"
  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e8/e8/b6cfd28fb430b2ec9923ad0147025bf8bbdf304b1eb3039b69f1ce44ed6e/charset-normalizer-2.0.11.tar.gz"
    sha256 "98398a9d69ee80548c762ba991a4728bfc3836768ed226b3945908d1a688371c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b0/b1/7bbf5181f8e3258efae31702f5eab87d8a74a72a0aa78bc8c08c1466e243/urllib3-1.26.8.tar.gz"
    sha256 "0e7c33d9a63e7ddfcb86780aac87befc2fbddf46c58dbb487e0855f7ceec283c"
  end

  def install
    virtualenv_install_with_resources

    # we depend on jsonschema, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.10")
    jsonschema = Formula["jsonschema"].opt_libexec
    (libexec/site_packages/"homebrew-jsonschema.pth").write jsonschema/site_packages
  end

  test do
    assert_match "notifiers", shell_output("#{bin}/notifiers --help")
  end
end
