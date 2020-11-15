class Fava < Formula
  include Language::Python::Virtualenv

  desc "Web interface for the double-entry bookkeeping software Beancount"
  homepage "https://beancount.github.io/fava/"
  url "https://files.pythonhosted.org/packages/14/c3/d0c16afc7e5af5b4cef1d2543fac8aedb1449370de9c7fb52f481e9b201c/fava-1.17.tar.gz"
  sha256 "efad3a4b5697b9d7ee29eff5dc0c8367fc1df37b1abacc8d0b2071602e94a6cd"
  license "MIT"
  head "https://github.com/beancount/fava.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f7de7a3f9c40808b50bd925cfadd1d143d87c53367142ab6e9fed62d66cad1a3" => :catalina
    sha256 "fe7e9d74295ae2ae43365b20c19d96323923de16b8c81c6f889118c6430519a8" => :mojave
    sha256 "2585cccc689cb38a31a05db245e8ed84a53a15e524e25658f9a2e5e2ab2fc865" => :high_sierra
  end

  depends_on "python@3.9"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/f0/cb/80a4a274df7da7b8baf083249b0890a0579374c3d74b5ac0ee9291f912dc/attrs-20.3.0.tar.gz"
    sha256 "832aa3cde19744e49938b91fea06d69ecb9e649c93ba974535d08ad92164f700"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/41/1b/5ed6e564b9ca54318df20ebe5d642ab25da4118df3c178247b8c4b26fa13/Babel-2.9.0.tar.gz"
    sha256 "da031ab54472314f210b0adcff1588ee5d1d1d0ba4dbd07b94dba82bde791e05"
  end

  resource "beancount" do
    url "https://files.pythonhosted.org/packages/d4/77/5a50f2082fa837deabac7a2da7e477a3db3c7dc907b8e815e7134fa65e91/beancount-2.3.3.tar.gz"
    sha256 "d9a29839ea867d1dda7af1f4bf5d3959aa7c1574cd4a0bc86f69ee64c555c71c"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/6b/c3/d31704ae558dcca862e4ee8e8388f357af6c9d9acb0cad4ba0fbbd350d9a/beautifulsoup4-4.9.3.tar.gz"
    sha256 "84729e322ad1d5b4d25f805bfa05b902dd96450f43842c4e99067d5e1369eb25"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/ea/80/3d2dca1562ffa1929017c74635b4cb3645a352588de89e90d0bb53af3317/bottle-0.12.19.tar.gz"
    sha256 "a9d73ffcbc6a1345ca2d7949638db46349f5b2b77dac65d6494d45c23628da2c"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/fc/c8/0b52cf3132b4b85c9e83faa3e4d375575afeb3a1710c40b2b2cd2a3e5635/cachetools-4.1.1.tar.gz"
    sha256 "bbaa39c3dede00175df2dc2b03d0cf18dd2d32a7de7beb68072d13043c9edb20"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/e6/de/879cf857ae6f890dfa23c3d6239814c5471936b618c8fb0c8732ad5da885/certifi-2020.11.8.tar.gz"
    sha256 "f05def092c44fbf25834a51509ef6e631dc19765ab8a57b4e7ab85531f0a9cf4"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "cheroot" do
    url "https://files.pythonhosted.org/packages/6e/5c/0d39e6c17a3711e3c919635e3dcc50df964f2a970139d71ff859531a85f1/cheroot-8.4.6.tar.gz"
    sha256 "d6916161519682c1c7d85c569d6ad3c8bddbedc969fc49676897549a29c92752"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/4e/0b/cb02268c90e67545a0e3a37ea1ca3d45de3aca43ceb7dbf1712fb5127d5d/Flask-1.1.2.tar.gz"
    sha256 "4efa1ae2d7c9865af48986de8aeb8504bf32c7f3d6fdc9353d34b21f4b127060"
  end

  resource "Flask-Babel" do
    url "https://files.pythonhosted.org/packages/d7/fe/655e6a5a99ceb815fe839f0698956a9d6c7d5bcc06ca1ee7c6eb6dac154b/Flask-Babel-2.0.0.tar.gz"
    sha256 "f9faf45cdb2e1a32ea2ec14403587d4295108f35017a7821a2b1acb8cfd9257d"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/45/b6/af767599f4ea3abe55466e65f6886df591e3ce4eca48f71255901ea74196/google-api-core-1.23.0.tar.gz"
    sha256 "1bb3c485c38eacded8d685b1759968f6cf47dd9432922d34edb90359eaa391e2"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/72/21/fe4d456cf142d0cd801f8cacef7b598e9bf9e561db88f76c5faa12264dba/google-api-python-client-1.12.5.tar.gz"
    sha256 "1892cd490d164e5ec2f2168dc3b4fa0af68f36ca15a88b91bca1826b3d4f2829"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/65/1c/eee2dbfefe37855300e4f89245c698bb1713de215d191a5127317b418576/google-auth-1.23.0.tar.gz"
    sha256 "5176db85f1e7e837a646cd9cede72c3c404ccf2e3373d9ee14b2db88febad440"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/6c/5e/97a5e7573457020351a275c74c559dbe2ebe1c606119f991541c98ffa651/google-auth-httplib2-0.0.4.tar.gz"
    sha256 "8d092cc60fb16517b12057ec0bba9185a96e3b7169d86ae12eae98e645b7bc39"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/95/3f/a1282d82def57e0c28bab597d25785774a4e64433aac9cc136e65c500da8/googleapis-common-protos-1.52.0.tar.gz"
    sha256 "560716c807117394da12cecb0a54da5a451b5cf9866f1d37e9a5e2329a665351"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/98/3f/0769a851fbb0ecc458260055da67d550d3015ebe6b8b861c79ad00147bb9/httplib2-0.18.1.tar.gz"
    sha256 "8af66c1c52c7ffe1aa5dc4bcd7c769885254b0756e6e69f953c7f0ab49a70ba3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/23/a2/97899f6bd0e873fed3a7e67ae8d3a08b21799430fb4da15cfedf10d6e2c2/iniconfig-1.1.1.tar.gz"
    sha256 "bc3af051d7d14b2ee5ef9969666def0cd1a000e121eaea580d4a313df4b37f32"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/68/1a/f27de07a8a304ad5fa817bbe383d1238ac4396da447fa11ed937039fa04b/itsdangerous-1.1.0.tar.gz"
    sha256 "321b033d07f2a4136d3ec762eac9f16a10ccd60f53c0c91af90217ace7ba1f19"
  end

  resource "jaraco.functools" do
    url "https://files.pythonhosted.org/packages/89/e1/773ecbf42ada8dc31459837c76316478df975cf6d9fcc171075548bd7cac/jaraco.functools-3.0.1.tar.gz"
    sha256 "9fedc4be3117512ca3e03e1b2ffa7a6a6ffa589bfb7d02bfb324e55d493b94f4"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/64/a7/45e11eebf2f15bf987c3bc11d37dcc838d9dc81250e67e4c5968f6008b6c/Jinja2-2.11.2.tar.gz"
    sha256 "89aab215427ef59c34ad58735269eb58b1a5808103067f7bb9d5836c651b3bb0"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/c5/2f/a0d8aa3eee6d53d5723d89e1fc32eee11e76801b424e30b55c7aa6302b01/lxml-4.6.1.tar.gz"
    sha256 "c152b2e93b639d1f36ec5a8ca24cde4a8eefb2b6b83668fcd8e83a67badcb367"
  end

  resource "markdown2" do
    url "https://files.pythonhosted.org/packages/f5/d0/404331c3c19a716f951ef4e32f53d43bcc8d07fc6a8210f245cecf4fab77/markdown2-2.3.10.tar.gz"
    sha256 "85956d8119fa6378156fef65545d66705a842819d2e1b50379a2b9d2aaa17cf0"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/b0/0f/da7bf94283720a148fe4d7335c8b74b67c8e978c6498487d699a0d86c72b/more-itertools-8.6.0.tar.gz"
    sha256 "b3a9005928e5bed54076e6e549c792b306fddfe72b2d1d22dd63d42d5d3899cf"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/55/fd/fc1aca9cf51ed2f2c11748fa797370027babd82f87829c7a8e6dbe720145/packaging-20.4.tar.gz"
    sha256 "4357f74f47b9c12db93624a82154e9b120fa8293699949152b22065d556079f8"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f8/04/7a8542bed4b16a65c2714bf76cf5a0b026157da7f75e87cc88774aa10b14/pluggy-0.13.1.tar.gz"
    sha256 "15b2acde666561e1298d71b523007ed7364de07029219b604cf808bfa1c765b0"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/12/ba/d6d9f1432663ab5623f761c86be11e7f2f6fb28348612f48fb082d3cfcea/protobuf-3.14.0.tar.gz"
    sha256 "1d63eb389347293d8915fb47bee0951c7b5dab522a4a60118b9a18f33e21f8ce"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/97/a6/ab9183fe08f69a53d06ac0ee8432bc0ffbb3989c575cc69b73a0229a9a99/py-1.9.0.tar.gz"
    sha256 "9ca6883ce56b4e8da7e79ac18787889fa5206c79dcc67fb065376cd2fe03f342"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/88/87/72eb9ccf8a58021c542de2588a867dbefc7556e14b2866d1e40e9e2b587e/pyasn1-modules-0.2.8.tar.gz"
    sha256 "905f84c712230b2c592c19470d3ca8d552de726050d1d1716282a1f6146be65e"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/d4/df/bd7c25c4fe809a17315b3fc9878edf48d31dde7b431b6836848b063c0428/pytest-6.1.2.tar.gz"
    sha256 "c0a7e94a8cdbc5422a51ccdad8e6f1024795939cc89159a0ae7f0b316ad3823e"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/e3/85/1aff76b966622868a73717abd8b501a3c91890e23a65e5f574ff6df1970f/python-magic-0.4.18.tar.gz"
    sha256 "b757db2a5289ea3f1ced9e60f072965243ea43a2221430048fd8cacab17be0ce"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/09/07/448a8887c7195450604dfc0305d80d74324c36ee18ed997664051d4bffe3/pytz-2020.4.tar.gz"
    sha256 "3e6b7dd2d1e0a59084bcee14a17af60c5c562cdc16d828e8eba2e683d3a7e268"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9f/14/4a6542a078773957aa83101336375c9597e6fe5889d20abda9c38f9f3ff2/requests-2.25.0.tar.gz"
    sha256 "7f1a0b932f4a60a1a65caa4263921bb7d9ee911957e0ae4a23a6dd08185ad5f8"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/a2/d5/04b8a9719149583fec76efdff2e7a81c6e3cc34909ee818d3fbf115edc2e/rsa-4.6.tar.gz"
    sha256 "109ea5a66744dd859bf16fe904b8d8b627adafb9408753161e766a92e7d681fa"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/49/45/a16db4f0fa383aaf0676fb7e3c660304fe390415c243f41a77c7f917d59b/simplejson-3.17.2.tar.gz"
    sha256 "75ecc79f26d99222a084fbdd1ce5aad3ac3a8bd535cd9059528452da38b68841"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/3e/db/5ba900920642414333bdc3cb397075381d63eafc7e75c2373bbc560a9fa1/soupsieve-2.0.1.tar.gz"
    sha256 "a59dc181727e95d25f781f0eb4fd1825ff45590ec8ff49eadfd7f1a537cc0232"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/42/da/fa9aca2d866f932f17703b3b5edb7b17114bb261122b6e535ef0d9f618f8/uritemplate-3.0.1.tar.gz"
    sha256 "5af8ad10cec94f215e3f48112de2022e1d5a37ed427fbd88652fa908f2ab7cae"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/29/e6/d1a1d78c439cad688757b70f26c50a53332167c364edb0134cadd280e234/urllib3-1.26.2.tar.gz"
    sha256 "19188f96923873c92ccb987120ec4acaa12f0461fa9ce5d3d0772bc965a39e08"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/10/27/a33329150147594eff0ea4c33c2036c0eadd933141055be0ff911f7f8d04/Werkzeug-1.0.1.tar.gz"
    sha256 "6c80b1e5ad3665290ea39320b91e1be1e0d5f60652b964a3070216de83d2e47c"
  end

  def install
    virtualenv_install_with_resources
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

    fork do
      exec "#{bin}/fava", "--port=#{port}", "#{testpath}/example.ledger"
    end

    # Wait for fava to start up
    sleep 5

    cmd = "curl -sIm1 -XGET http://localhost:#{port}/beancount/income_statement/"
    assert_match(/200 OK/m, shell_output(cmd))
  end
end
