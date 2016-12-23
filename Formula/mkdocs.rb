class Mkdocs < Formula
  include Language::Python::Virtualenv

  desc "Project documentation with Markdown"
  homepage "http://www.mkdocs.org/"
  url "https://github.com/mkdocs/mkdocs/archive/0.16.1.tar.gz"
  sha256 "b665679d7c6da47e734a00e89f823e478cc57389ffeb49266de68a804f803f83"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "31db903b25de353f1149249d6e184425d6b8926f77cc1e818f3deba828542907" => :sierra
    sha256 "2751b2e79c05ae4c1c2c682179e3b4b59c479bbf08c60cdff588b1729f184a25" => :el_capitan
    sha256 "0470e202fd4adcf8c5ece8f48595ed5003921905adc33847739d00698fe179db" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "backports_abc" do
    url "https://files.pythonhosted.org/packages/68/3c/1317a9113c377d1e33711ca8de1e80afbaf4a3c950dd0edfaf61f9bfe6d8/backports_abc-0.5.tar.gz"
    sha256 "033be54514a03e255df75c5aee8f9e672f663f93abb723444caec8fe43437bde"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/4f/75/e1bc6e363a2c76f8d7e754c27c437dbe4086414e1d6d2f6b2a3e7846f22b/certifi-2016.9.26.tar.gz"
    sha256 "8275aef1bbeaf05c53715bfc5d8569bd1e04ca1e8e69608cc52bcaac2604eb19"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/7a/00/c14926d8232b36b08218067bcd5853caefb4737cda3f0a47437151344792/click-6.6.tar.gz"
    sha256 "cc6a19da8ebff6e7074f731447ef7e112bd23adf3de5c597cf9989f2fd8defe9"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/f2/2f/0b98b06a345a761bec91a079ccae392d282690c2d8272e708f4d10829e22/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "livereload" do
    url "https://files.pythonhosted.org/packages/ba/71/2660028c74cb3289d4b9fd06632aa277b4edbe0747b7219cd92307fa19ba/livereload-2.5.0.tar.gz"
    sha256 "bc708b46e22dff243c02e709c636ffeb8a64cdd019c95a215304e6ce183c4859"
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/d4/32/642bd580c577af37b00a1eb59b0eaa996f2d11dfe394f3dd0c7a8a2de81a/Markdown-2.6.7.tar.gz"
    sha256 "daebf24846efa7ff269cfde8c41a48bb2303920c7b2c7c5e04fa82e6282d05c0"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "singledispatch" do
    url "https://files.pythonhosted.org/packages/d9/e9/513ad8dc17210db12cb14f2d4d190d618fb87dd38814203ea71c87ba5b68/singledispatch-3.4.0.3.tar.gz"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/1e/7c/ea047f7bbd1ff22a7f69fe55e7561040e3e54d6f31da6267ef9748321f98/tornado-4.4.2.tar.gz"
    sha256 "2898f992f898cd41eeb8d53b6df75495f2f423b6672890aadaf196ea1448edcc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # build a very simple site that uses the "readthedocs" theme.
    (testpath/"mkdocs.yml").write <<-EOS.undent
      site_name: MkLorum
      pages:
        - Home: index.md
      theme: readthedocs
    EOS
    mkdir testpath/"docs"
    (testpath/"docs/index.md").write <<-EOS.undent
      # A heading

      And some deeply meaningful prose.
    EOS
    system "#{bin}/mkdocs", "build", "--clean"
  end
end
