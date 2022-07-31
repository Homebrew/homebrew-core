class Cruft < Formula
  include Language::Python::Virtualenv

  desc "Utility that creates projects from templates and maintains the cruft afterwards"
  homepage "https://cruft.github.io/cruft/"
  url "https://files.pythonhosted.org/packages/da/41/217438f182d447104fe2dba63527191e2e4e49270afcc3e3f58419980615/cruft-2.11.0.tar.gz"
  sha256 "dd1edac65f039faca23f63bec46e774d2d3e8af86fd67e6b62cbfecef3d6ff18"
  license "MIT"
  head "https://github.com/cruft/cruft.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90df52cd4cfdf0977c06ea2fdb75730bb389143f2c901391b50ee2ec9c943fe6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41fcdf213a2dd3a72626ebb12f98e43a3444e4950f55eae370019a28813b7f25"
    sha256 cellar: :any_skip_relocation, monterey:       "e94ac31c4cd2b50c9b2517b61dc77e220396198ba8585b9dc065e01b446abb08"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e3ad02c82f7508c4abb2eff42e8084a3563e3e9c92f374fb7faa1f9d4e8213c"
    sha256 cellar: :any_skip_relocation, catalina:       "b7f8c2b458882e37cc1d577c65be76eee9322e8fd3b43b8866f35330b95d6ae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89e8752784fa125df67127d6ae43ac5b37026f9fed1378f99c62f4c6b76139da"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/48/28/30a5748af715b0ab9c2b81cf08bd9e261e47a6261e247553afb7f6421b24/arrow-1.2.2.tar.gz"
    sha256 "05caf1fd3d9a11a1135b2b6f09887421153b94558e5ef4d090b567b47173ac2b"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/a7/fe/7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49b/binaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/31/a2/12c090713b3d0e141f367236d3a8bdc3e5fca0d83ff3647af4892c16c205/chardet-5.0.0.tar.gz"
    sha256 "0368df2bfd78b5fc20572bb4e9bb7fb53e2c094f60ae9993339e8671d0afb8aa"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/93/1d/d9392056df6670ae2a29fcb04cfa5cee9f6fbde7311a1bb511d4115e9b7a/charset-normalizer-2.1.0.tar.gz"
    sha256 "575e708016ff3a5e3681541cb9d79312c416835686d054a23accb873b254f413"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "cookiecutter" do
    url "https://files.pythonhosted.org/packages/96/43/65a3dad94dceaaaa12807ce4d4eff1064db6e91a8c6fb6945e3e61e63552/cookiecutter-2.1.1.tar.gz"
    sha256 "f3982be8d9c53dac1261864013fdec7f83afd2e42ede6f6dd069c5e149c540d5"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/fc/44/64e02ef96f20b347385f0e9c03098659cb5a1285d36c3d17c56e534d80cf/gitdb-4.0.9.tar.gz"
    sha256 "bac2fd45c0a1c9cf619e63a90d62bdc63892ef92387424b855792a6cabe789aa"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/d6/39/5b91b6c40570dc1c753359de7492404ba8fe7d71af40b618a780c7ad1fc7/GitPython-3.1.27.tar.gz"
    sha256 "1c885ce809e8ba2d88a29befeb385fcea06338d3640712b59ca623c220bb5704"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jinja2-time" do
    url "https://files.pythonhosted.org/packages/de/7c/ee2f2014a2a0616ad3328e58e7dac879251babdb4cb796d770b5d32c469f/jinja2-time-0.2.0.tar.gz"
    sha256 "d14eaa4d315e7688daa4969f616f226614350c48730bfa1692d2caebd8c90d40"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/5d/45/915967d7bcc28fd12f36f554e1a64aeca36214f2be9caf87158168b5a575/python-slugify-6.1.2.tar.gz"
    sha256 "272d106cb31ab99b3496ba085e3fea0e9e76dcde967b5e9992500d1f785ce4e1"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/cf/f9/27c5cd9ab067e3ece4cecb920c33f38cc986f839b12de19650fd49dc3c63/typer-0.6.1.tar.gz"
    sha256 "2d5720a5e63f73eaf31edaa15f6ab87f35f0690f8ca233017d7d23d743a91d73"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/6d/d5/e8258b334c9eb8eb78e31be92ea0d5da83ddd9385dc967dd92737604d239/urllib3-1.26.11.tar.gz"
    sha256 "ea6e8fb210b19d950fab93b60c9009226c63a28808bc8386e05301e25883ac0a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"cruft", "create", "--no-input", "https://github.com/audreyr/cookiecutter-pypackage.git"
    assert (testpath/"python_boilerplate").directory?
    assert_predicate testpath/"python_boilerplate/.cruft.json", :exist?
  end
end
