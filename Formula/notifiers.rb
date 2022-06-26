class Notifiers < Formula
  include Language::Python::Virtualenv

  desc "Easy way to send notifications"
  homepage "https://pypi.org/project/notifiers/"
  url "https://files.pythonhosted.org/packages/54/fc/aa5de032cc8d9ee41ceba7bbea98e2ed7090d7d95465dfe0179eb937146f/notifiers-1.3.3.tar.gz"
  sha256 "9fd8d95ab1ebcd3852423755aa90cbb0f72a805ca77af0d8c9ad7af445f58399"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "960b18b529618ca66159c80f8a0f81aa3de37e8535a3d2843a6f76d6a7845e37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cbbc0c730bbc6f727fc6bb70ab02c3d13ff7dc5f51da423d6725d74214a55df"
    sha256 cellar: :any_skip_relocation, monterey:       "5dc812c0538ddd386a2ebb4f672506392c6118cd33f24141ff6584ee8ce945d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd1ed9363710d49d6985fa0f25aa13997529623e4b54f0e0fb7a15132a539809"
    sha256 cellar: :any_skip_relocation, catalina:       "5025fa16775b182eab226629f9089cdbd15705894edf4b8a9f2684b769884555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99764544a3a20321070f6abdad5f9f1e56758b4d076aad19672790d0489c4173"
  end

  depends_on "python@3.10"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

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

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/26/67/36cfd516f7b3560bbf7183d7a0f82bb9514d2a5f4e1d682a8a1d55d8031d/jsonschema-4.4.0.tar.gz"
    sha256 "636694eb41b3535ed608fe04129f26542b59ed99808b4f688aa32dcf55317a83"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/42/ac/455fdc7294acc4d4154b904e80d964cc9aae75b087bbf486be04df9f2abd/pyrsistent-0.18.1.tar.gz"
    sha256 "d4d61f8b993a7255ba714df3aca52700f8125289f84f704cf80916517c46eb96"
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
  end

  test do
    assert_match "notifiers", shell_output("#{bin}/notifiers --help")
  end
end
