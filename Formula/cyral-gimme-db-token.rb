class CyralGimmeDbToken < Formula
  include Language::Python::Virtualenv

  desc "Eases using Cyral for SSO login to databases"
  homepage "https://cyral.com/docs/connect/repo-connect/#cli-token-retriever-for-sso"
  url "https://files.pythonhosted.org/packages/2d/a4/89c570d7939cf4560ee49017ba1dfe5e0174f15d18f60e532fbb2586d65d/cyral-gimme-db-token-0.8.2.tar.gz"
  sha256 "ba2e8258e231324f76bdf34dabce41f75dbef67b7246cbe1db030ca75e65bed8"
  license "Apache-2.0"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_ventura:  "f66deb5f999bd39d5ad456ace89a0d8a6779fff99e9301097e540e8e7df0227d"
    sha256 cellar: :any,                 arm64_monterey: "de7edcc483a1f1291f35ef5b1b22d69fe5e5741bd30c55d7f5575880ab8e6f17"
    sha256 cellar: :any,                 arm64_big_sur:  "ddcf51d9f53a471b7b32b7fca47a444d5388c1996cc8944d2f984606f0a64243"
    sha256 cellar: :any,                 ventura:        "8200b54b6b6437a87d3143fceb7947064ff2461b993a728114c598f434ea4b71"
    sha256 cellar: :any,                 monterey:       "e34a3e84058724a726020806a7de83b5522ac926b63be7830e19eafabf0e063a"
    sha256 cellar: :any,                 big_sur:        "f3837fefbaabeafa63a6981d4b454a02a421b3f1e1f3ebbe2d97a8b55313fa20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cebf25df85a278f3064210efde773fa209f2dceceabb64765830e7b678fccda2"
  end

  # `pkg-config`, `rust`, and `openssl@3` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  resource "awscli" do
    url "https://files.pythonhosted.org/packages/88/30/340f473dbdc4ce5e347eb5c5c5c4864cc7a9b14cfa69bafbaebf3917f6cd/awscli-1.27.138.tar.gz"
    sha256 "3a1fcf1a4d687c485b55d751e82307e51f5ced7e98147224858b896cddb40b3e"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/6d/f4/07a2ad9a3ba8e393616ad9401ca2f73d22a4144f893c2e6735a37a212fe1/botocore-1.29.138.tar.gz"
    sha256 "31edc237088c104f7a05887646bbec31d7459dd2e108fd90cbffa315902817e2"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
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
    url "https://files.pythonhosted.org/packages/fa/f3/f4b8c175ea9a1de650b0085858059050b7953a93d66c97ed89b93b232996/cryptography-39.0.2.tar.gz"
    sha256 "bc5b871e977c8ee5a1bbc42fa8d19bcc08baf0c51cbf1586b0e87a2694dde42f"
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
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/49/bd/def2ab4c04063a5e114963aae90bcd3e3aca821a595124358b3b00244407/s3transfer-0.6.1.tar.gz"
    sha256 "640bb492711f4c0c0905e1f62b6aaeb771881935ad27884852411f8e9cacbca9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  # patch to use latest poetry_core to fix build
  patch :DATA

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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
