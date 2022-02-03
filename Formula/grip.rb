class Grip < Formula
  include Language::Python::Virtualenv

  desc "GitHub Markdown previewer"
  homepage "https://github.com/joeyespo/grip"
  url "https://files.pythonhosted.org/packages/08/c7/027e68120a092a0802548bbd45659712a3eb93c9a8aa29569b7239d3b673/grip-4.6.0.tar.gz"
  sha256 "554f9a272b385b886e1b903f0b4323778009c0a681c096950a4bed14e299c79a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09105fcd1084565db2b5e649864af1fb80941638beba1dcca290791d6c526ac2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfc5788cdd426b916854e205ef98a6216afd86c8acbcedd1590b57ac8276cca2"
    sha256 cellar: :any_skip_relocation, monterey:       "163ab17a989cb816ada5aa778db688b3b2f2e371b523d9601fff1da489e3f7b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "60f6b63e4dc026f60c4c8e0321c1c40f962662fba4d355edde94d0bc59435691"
    sha256 cellar: :any_skip_relocation, catalina:       "20845cfa7d409cd8a401f4fd9cc78dc2cf5c2b14ded670d4c1a2b0a90fa8030f"
    sha256 cellar: :any_skip_relocation, mojave:         "1a1fc037a3861aee7a694a6bfe43e8accd32165d01ca2815c2a4c7b45e573b67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "200d3c977a0488bede732b29557e50b139bf675e10d82b0829d8ae46573bd73f"
  end

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

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/95/40/b976286b5e7ba01794a7e7588e7e7fa27fb16c6168fa849234840bf0f61d/Flask-2.0.2.tar.gz"
    sha256 "7b2fb8e934ddd50731893bdcdb00fc8c0315916f9fcd50d22c7cc1a95ab634e2"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/58/66/d6c5859dcac92b442626427a8c7a42322068c5cd5d4a463ce78b93f730b7/itsdangerous-2.0.1.tar.gz"
    sha256 "9e724d68fc22902a1435351f84c3fb8623f303fffcc566a4cb952df8c572cff0"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/91/a5/429efc6246119e1e3fbf562c00187d04e83e54619249eb732bb423efa6c6/Jinja2-3.0.3.tar.gz"
    sha256 "611bb273cd68f3b993fabdc4064fc858c5b47a973cb5aa7999ec1ba405c87cd7"
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/15/06/d60f21eda994b044cbd496892d4d4c5c708aa597fcaded7d421513cb219b/Markdown-3.3.6.tar.gz"
    sha256 "76df8ae32294ec39dcf89340382882dfa12975f87f45c3ed1ecdb1e8cefc7006"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "path-and-address" do
    url "https://files.pythonhosted.org/packages/2b/b5/749fab14d9e84257f3b0583eedb54e013422b6c240491a4ae48d9ea5e44f/path-and-address-2.0.1.zip"
    sha256 "e96363d982b3a2de8531f4cd5f086b51d0248b58527227d43cf5014d045371b7"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b0/b1/7bbf5181f8e3258efae31702f5eab87d8a74a72a0aa78bc8c08c1466e243/urllib3-1.26.8.tar.gz"
    sha256 "0e7c33d9a63e7ddfcb86780aac87befc2fbddf46c58dbb487e0855f7ceec283c"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/83/3c/ecdb36f49ab06defb0d5a466cfeb4ae90a55d02cfef379f781da2801a45d/Werkzeug-2.0.2.tar.gz"
    sha256 "aa2bb6fc8dee8d6c504c0ac1e7f5f7dc5810a9903e793b6f715a9f015bdadb9a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "<strong>Homebrew</strong> is awesome",
                 pipe_output("#{bin}/grip - --export -", "**Homebrew** is awesome.")
  end
end
