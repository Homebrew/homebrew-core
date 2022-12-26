class CyralGimmeDbToken < Formula
  include Language::Python::Virtualenv

  desc "Eases using Cyral for SSO login to databases"
  homepage "https://cyral.com/docs/connect/repo-connect/#cli-token-retriever-for-sso"
  url "https://files.pythonhosted.org/packages/96/44/1810cb177f63217550a1cb0f38adf5652636167062e78dd6b1fb3207faf5/cyral-gimme-db-token-0.8.1.tar.gz"
  sha256 "7f49ac2410870b895118f39051264ac047d9f6537d7cbdd8828a7627681c8857"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "6d25345463d0c2932be0a23a31fd3e1861bea45358d1dafee19a2fecfdb009e2"
    sha256 cellar: :any,                 arm64_monterey: "0b28ffa9ac0704e75f0b09fc30a3040a7fed22bca81d45a11618aced477a0708"
    sha256 cellar: :any,                 arm64_big_sur:  "8db9650eb0f4b71e5f654e2882f9b161ef6e6a283f6b4ea527fddf052d3fc7e0"
    sha256 cellar: :any,                 ventura:        "411e839bf44b075c519c8dac4642f9b01bcf99887bf96c06635b8a80d5928232"
    sha256 cellar: :any,                 monterey:       "951f4f9252816b0c85f5ff120c8cde10d55b8b604e4ce6bc301eb9a4381b2740"
    sha256 cellar: :any,                 big_sur:        "90883ea1be8e6b62b80e88994026c16974d976aee235dc660022ca1e9f63b136"
    sha256 cellar: :any,                 catalina:       "4f438f8fc840756c10f1f38b9cbf6fe41d9370b4337d082f8e3eba2c1de4e6c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27f95a29f042afe65d24c0bdad74d8470d4054e888a45b4ae8d0b4fd274e6a0a"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "openssl@1.1"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "awscli" do
    url "https://files.pythonhosted.org/packages/11/39/40ee46b103ca3b143cb11bbb1c6cb77436b5053c16e99cd985f32705de9d/awscli-1.27.8.tar.gz"
    sha256 "21a9f2339bb3b4a9e14e12da1e4f64f9c08b1b495f869fda793d935c0e3995ea"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/9c/62/0e7a8c2bc63c3529db0ca3ee4c0f5b60a65165e594d1487b13b6524ddccd/botocore-1.29.8.tar.gz"
    sha256 "48cf33d7c513320711321c3b303b0c9810b23e15fa03424f7323883e4ce6cef8"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/10/a7/51953e73828deef2b58ba1604de9167843ee9cd4185d8aaffcb45dd1932d/cryptography-36.0.2.tar.gz"
    sha256 "70f8f4f7bb2ac9f340655cbac89d68c527af5bb4387522a8413e841e3e6628c9"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/2f/e0/3d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219d/docutils-0.16.tar.gz"
    sha256 "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  # patch to use latest poetry_core to fix build
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}/gimme_db_token --version")
    assert_match "There was an error fetching your token.",
      shell_output("#{bin}/gimme_db_token --address localhost --timeout 1")
    assert_match "Error: Invalid value", shell_output("#{bin}/gimme_db_token unsupported 2>&1", 2)
  end
end

__END__
diff --git a/pyproject.toml b/pyproject.toml
index f88b284..e8b5fbd 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -28,6 +28,5 @@ flake8 = "^3.8.4"
 [tool.poetry.scripts]
 gimme_db_token = "gimme_db_token.__main__:run"
 [build-system]
-requires = ["poetry>=0.12"]
-build-backend = "poetry.masonry.api"
-
+requires = ["poetry_core>=1.0.0"]
+build-backend = "poetry.core.masonry.api"
