class Fava < Formula
  include Language::Python::Virtualenv

  desc "Web interface for the double-entry bookkeeping software Beancount"
  homepage "https://beancount.github.io/fava/"
  url "https://files.pythonhosted.org/packages/fe/ef/4ca533948f1e92a1efa005e58baf8c75157534dc4e22bb157f3ea70cd85d/fava-1.30.tar.gz"
  sha256 "1c1bec15f94a18f5651dcf691c1f15086183d562c34fd4db8cbd55e350b784a5"
  license "MIT"
  head "https://github.com/beancount/fava.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "60d40b59af46518f1a9450d26f00adc12415fe9924c77a160334fc63039c344d"
    sha256 cellar: :any,                 arm64_sonoma:  "1ac0d5517a56acf1d8a38910957a6bfcfa54251dddece53fb55f8f310019faa8"
    sha256 cellar: :any,                 arm64_ventura: "f7b1b7deb1f8771f9476feea68bdb0f55c54c67d7791b53221eec1a9938127d7"
    sha256 cellar: :any,                 sonoma:        "d8599d6d5355d344337d49e805901b8c486b7dca29689cb9261fc7ff86d312b4"
    sha256 cellar: :any,                 ventura:       "980baded75d5464301f5de212601d4ecda33c122d8a72de1bdea7effe73d8b85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d53a63a9aa00ee18a02216f65fad0f7faf74dab486ccd1a9272f69b94883468d"
  end

  depends_on "meson" => :build # for beancount
  depends_on "ninja" => :build # for beancount
  depends_on "rust" => :build # for watchfiles
  depends_on "certifi"
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "patchelf" => :build # for beancount
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/f6/40/318e58f669b1a9e00f5c4453910682e2d9dd594334539c7b7817dabb765f/anyio-4.7.0.tar.gz"
    sha256 "2f834749c602966b7d456a7567cafcb309f96482b5081d14ac93ccd457f9dd48"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/2a/74/f1bc80f23eeba13393b7222b11d95ca3af2c1e28edca18af487137eefed9/babel-2.16.0.tar.gz"
    sha256 "d1f3554ca26605fe173f3de0c65f750f5a42f924499bf134de6423582298e316"
  end

  resource "beancount" do
    url "https://files.pythonhosted.org/packages/bb/0d/4bfa4e10c1dac42a8cf4bf43a7867b32b7779ff44272639b765a04b8553e/beancount-3.0.0.tar.gz"
    sha256 "cf6686869c7ea3eefc094ee13ed866bf5f7a2bb0c61e4d4f5df3e35f846cffdf"
  end

  resource "beangulp" do
    url "https://files.pythonhosted.org/packages/48/17/34f6901c68cb4f28bc6892e0c3058f3ac682e55bfa4dcb0351045c07a7ce/beangulp-0.1.1.tar.gz"
    sha256 "1fd131c76e5fda8c056efcc2f8a0d2bf5cd8141ef29060762601358f80f4a9b5"
  end

  resource "beanquery" do
    url "https://files.pythonhosted.org/packages/cd/04/8d9f3a48065fbf3f58826e8ea08bff35710ea8d542ed04654e87ec7b7b94/beanquery-0.1.0.tar.gz"
    sha256 "b69e099b8421b219bbcc3293af77e3c4ccad7ab25bf520fee48788672ffbf64a"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/b3/ca/824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58/beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "cheroot" do
    url "https://files.pythonhosted.org/packages/63/e2/f85981a51281bd30525bf664309332faa7c81782bb49e331af603421dbd1/cheroot-10.0.1.tar.gz"
    sha256 "e0b82f797658d26b8613ec8eb563c3b08e6bd6a7921e9d5089bd1175ad1b1740"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/89/50/dff6380f1c7f84135484e176e0cac8690af72fa90e932ad2a0a60e28c69b/flask-3.1.0.tar.gz"
    sha256 "5f873c5184c897c8d9d1b05df1e3d01b14910ce69607a117bd3277098a5836ac"
  end

  resource "flask-babel" do
    url "https://files.pythonhosted.org/packages/58/1a/4c65e3b90bda699a637bfb7fb96818b0a9bbff7636ea91aade67f6020a31/flask_babel-4.0.0.tar.gz"
    sha256 "dbeab4027a3f4a87678a11686496e98e1492eb793cbdd77ab50f4e9a2602a593"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/ab/23/9894b3df5d0a6eb44611c36aec777823fc2e07740dabbd0b810e19594013/jaraco_functools-4.1.0.tar.gz"
    sha256 "70f7e0e2ae076498e212562325e805204fc092d7b4c17e0e86c959e249701a9d"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/af/92/b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccff/jinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "markdown2" do
    url "https://files.pythonhosted.org/packages/a0/61/d3c0c21280ba1fc348822a4410847cf78f99bba8625755a5062a44d2e228/markdown2-2.5.2.tar.gz"
    sha256 "3ac02226a901c4b2f6fc21dbd17c26d118d2c25bcbb28cee093a1f8b5c46f3f1"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/51/78/65922308c4248e0eb08ebcbe67c95d48615cc6f27854b6f2e57143e9178f/more-itertools-10.5.0.tar.gz"
    sha256 "5482bfef7849c25dc3c6dd53a6173ae4795da2a41a80faea6700d9f5846c5da6"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/3a/31/3c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3f/pytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/3d/29/085111f19717f865eceaf0d4397bf3e76b08d60428b076b64e2a1903706d/simplejson-3.19.3.tar.gz"
    sha256 "8e086896c36210ab6050f2f9f095a5f1e03c83fa0e7f296d6cba425411364680"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/d7/ce/fbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfb/soupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "tatsu" do
    url "https://files.pythonhosted.org/packages/09/f6/d53b45ea138e24199486e11deadedf06d0bedc9373911582b57a484f3d59/TatSu-5.7.4.zip"
    sha256 "ebd8212323328115bc4967db9a40d7f15b627db4663290c64e5ef8fe71dca0ae"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/3c/7e/4569184ea04b501840771b8fcecee19b2233a8b72c196061263c0ef23c0b/watchfiles-1.0.3.tar.gz"
    sha256 "f3ff7da165c99a5412fe5dd2304dd2dbaaaa5da718aad942dcb3a178eaa70c56"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/9f/69/83029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71e/werkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"fava", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    # Find an available port
    port = free_port

    (testpath/"example.ledger").write <<~EOS
      2020-01-01 open Assets:Checking
      2020-01-01 open Equity:Opening-Balances
      2020-01-01 txn "Opening Balance"
        Assets:Checking 10.00 USD
        Equity:Opening-Balances
    EOS

    spawn bin/"fava", "--port=#{port}", testpath/"example.ledger"

    # Wait for fava to start up
    sleep 10

    cmd = "curl -sIm1 -XGET http://localhost:#{port}/beancount/income_statement/"
    assert_match(/200 OK/m, shell_output(cmd))
  end
end
