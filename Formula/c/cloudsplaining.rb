class Cloudsplaining < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM Security Assessment tool"
  homepage "https://cloudsplaining.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/d1/64/ba28b9b1854a40bcaae318da0e0fe147bd25999e496a8382a5a67c463db1/cloudsplaining-0.8.2.tar.gz"
  sha256 "733085a7648e45714a24e629d05d3dfd592d2925b21fe001c19f55a6d6c1581a"
  license "BSD-3-Clause"
  revision 5
  head "https://github.com/salesforce/cloudsplaining.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b0c2dee134c397054ef82196b325045fcfc4a950ae6da0bdbcab84b3f00c470e"
    sha256 cellar: :any,                 arm64_sequoia: "306d4bceb027bbfa4e455368b26f23f1d9ac7a7eb981035996d21071421877a1"
    sha256 cellar: :any,                 arm64_sonoma:  "3eec4c07f220bbab44846ecce2a96ff72199e9fe1c7b065634214f81b4d8a8a5"
    sha256 cellar: :any,                 sonoma:        "81025860afefc33b51f5e5b3b3b9e13a6cfff1b4882776087b3be67d626a3f81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "456f88b27c446e242533c352d1817a0d1a2edf894011df19a968e12ded753526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a6085f256271bec1b3fec6caf31a1e9a7ca9eb515276c87ba7e31771c18deee"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c3/b0/1c6a16426d389813b48d95e26898aff79abbde42ad353958ad95cc8c9b21/beautifulsoup4-4.14.3.tar.gz"
    sha256 "6292b1c5186d356bba669ef9f7f051757099565ad9ada5dd630bd9de5fa7fb86"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/0a/37/78c630d1308964aa9abf44951d9c4df776546ff37251ec2434944e205c4e/boto3-1.43.6.tar.gz"
    sha256 "e6315effaf12b890b99956e6f8e2c3000a3f64e4ee91943cec3895ce9a836afb"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/79/a7/23d0f5028011455096a1eeac0ddf3cbe147b3e855e127342f8202552194d/botocore-1.43.6.tar.gz"
    sha256 "b1e395b347356860398da42e61c808cf1e34b6fa7180cf2b9d87d986e1a06ba0"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/76/4b/3d870836119dbe9a5e3c9a61af8cc1a8b69d75aea564572e385882d5aefb/cached_property-2.0.1.tar.gz"
    sha256 "484d617105e3ee0e4f1f58725e72a8ef9e93deee462222dbd51cd91230897641"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "click-option-group" do
    url "https://files.pythonhosted.org/packages/ef/ff/d291d66595b30b83d1cb9e314b2c9be7cfc7327d4a0d40a15da2416ea97b/click_option_group-0.5.9.tar.gz"
    sha256 "f94ed2bc4cf69052e0f29592bd1e771a1789bd7bfc482dd0bc482134aff95823"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/05/b1/efac073e0c297ecf2fb33c346989a529d4e19164f1759102dee5953ee17e/idna-3.14.tar.gz"
    sha256 "466d810d7a2cc1022bea9b037c39728d51ae7dad40d480fc9b7d7ecf98ba8ee3"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/2b/f4/69fa6ed85ae003c2378ffa8f6d2e3234662abd02c10d216c0ba96081a238/markdown-3.10.2.tar.gz"
    sha256 "994d51325d25ad8aa7ce4ebaec003febcce822c3f8c911e3b17c52f7f589f950"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/7e/0c/964746fcafbd16f8ff53219ad9f6b412b34f345c75f384ad434ceaadb538/orjson-3.11.9.tar.gz"
    sha256 "4fef17e1f8722c11587a6ef18e35902450221da0028e65dbaaa543619e68e48f"
  end

  resource "policy-sentry" do
    url "https://files.pythonhosted.org/packages/2f/88/2ae4e253775a6b20766e49d9f4552a73d559d0815cf4d8789f3144241c66/policy_sentry-0.14.2.tar.gz"
    sha256 "a6c3d86a449cb4a40c149f2a0241fe0101da594e42f63a20a895f1322a07b708"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/9b/ec/7c692cde9125b77e84b307354d4fb705f98b8ccad59a036d5957ca75bfc3/s3transfer-0.17.0.tar.gz"
    sha256 "9edeb6d1c3c2f89d6050348548834ad8289610d886e5bf7b7207728bd43ce33a"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/fb/2e/8da627b65577a8f130fe9dfa88ce94fcb24b1f8b59e0fc763ee61abef8b8/schema-0.7.8.tar.gz"
    sha256 "e86cc08edd6fe6e2522648f4e47e3a31920a76e82cce8937535422e310862ab5"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/7b/ae/2d9c981590ed9999a0d91755b47fc74f74de286b0f5cee14c9269041e6c4/soupsieve-2.8.3.tar.gz"
    sha256 "3267f1eeea4251fb42728b6dfb746edc9acaffc4a45b27e19450b676586e8349"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"cloudsplaining", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloudsplaining --version")

    output = shell_output("#{bin}/cloudsplaining download 2>&1", 1)
    assert_match "botocore.exceptions.NoCredentialsError: Unable to locate credentials", output
  end
end
