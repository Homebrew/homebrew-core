class Fred < Formula
  include Language::Python::Virtualenv

  desc "Fully featured FRED Command-line Interface & Python API wrapper"
  homepage "https://fred.stlouisfed.org/docs/api/fred/"
  url "https://files.pythonhosted.org/packages/1e/7a/bb49f22f2ce33109ce5a5f8c7b85263cbc97bf9c9b44ba612c8380d3406f/fred-py-api-1.1.0.tar.gz"
  sha256 "f1eddf12fac2f26f656e317a11f61ec0129ba353187b659c20d05a600dba78c8"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfb4c1bf6b535c5f7c7c992c2b25b2c7aca62ac5e54e791414233215da5146a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc49cf4e2950bb6d3bc7829383213de37d290f528b14e6846ea0bc9b4b99697c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d9007f8a03afe73341e72874cef03139b0212fb1ddfb6f3f3d689bdf75ac56b"
    sha256 cellar: :any_skip_relocation, sonoma:         "bcda2ef59d19052c0fde6be2eec96210dbfa059fc0b58d294a1afe732f9833b1"
    sha256 cellar: :any_skip_relocation, ventura:        "90d6c3b569f8f3242550881ae83eec0ab63ff8332776f56b88c2b672ea6057df"
    sha256 cellar: :any_skip_relocation, monterey:       "9a99533eecbd67889c74922f97c333a1e064fc5fc84c869a694fd2325a0eab13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4cd1a96f3b6bbce10bbe0d474f99780504c5964d2b3b01a959a6dd62cca97a9"
  end

  depends_on "python-certifi"
  depends_on "python-click"
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
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # assert output & ensure exit code is 2
    # NOTE: this makes an API request to FRED with a purposely invalid API key
    assert_match \
      shell_output("#{bin}/fred --api-key sqwer1234asdfasdfqwer1234asdfsdf categories get-category -i 15", 2), \
      "Bad Request.  The value for variable api_key is not registered."
  end
end
