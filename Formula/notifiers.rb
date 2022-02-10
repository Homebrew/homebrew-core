class Notifiers < Formula
  include Language::Python::Virtualenv

  desc "Easy way to send notifications"
  homepage "https://pypi.org/project/notifiers/"
  url "https://files.pythonhosted.org/packages/fc/ae/1d670ba8e0dcfdad0ef3b7192bf3c399c2c488af99234c78e3132e20323d/notifiers-1.3.2.tar.gz"
  sha256 "56d84d91bb0b272c80a16535b7e2142ac05910f661313da576d8384eaa6852a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f6591af6782033a2f0b2f597a09faab6c232126702cdfdb5b171dd92805e47e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e940aae460e075a8bc29d6e1c0e1bef324f5a5e1768e6bcfcf9ff833e4d5cf1f"
    sha256 cellar: :any_skip_relocation, monterey:       "a730ceef022e525bbb25ef0ca7aa91bf85148fdf982b2925d16066bbd5083f1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf12e31868906b339c00d1a07c99748c1522ea05c2d78995610421dbbde5d353"
    sha256 cellar: :any_skip_relocation, catalina:       "15982233103b22e733b9dbf278dc5d44012b8b21e8d44589a06230a86b0d1d81"
    sha256 cellar: :any_skip_relocation, mojave:         "612a16751cbdc438e72a9a29fe21152059d875a9c89d26ba78e7b32e4e0c0147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0b71b638a99217dad808cba60bdfbae52ff6c3f05138b721cd8e6c662e10a80"
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
