class Mycli < Formula
  include Language::Python::Virtualenv

  desc "CLI for MySQL with auto-completion and syntax highlighting"
  homepage "https://www.mycli.net/"
  url "https://files.pythonhosted.org/packages/51/4d/85a667ecd543167933806e76ccb2708da67c7a18d272938f79d0e30e1a1d/mycli-2.30.3.tar.gz"
  sha256 "65e45b79ec71ced20cc5a1249f706d86ddb2f722e3208717c9d9203f3ae9a5d2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e40ec513c517b730983969a478a857160e01641c9a3f1c034e49b483fd0fd4f1"
    sha256 cellar: :any, arm64_tahoe:       "3c5422612b79ca71e64a63a21f4c3f93c9bcdaba4c3430a1dce7bd9cfb4ac90e"
    sha256 cellar: :any, arm64_sequoia:     "2b33430874a173ab6a5b98b6255d1c5e50684474401610d347d3d07fa4b04c7a"
    sha256 cellar: :any, arm64_linux:       "8b728c51e43533d352ba2c8550ea461f31ba032f148ddd5e622054c8bc238808"
    sha256 cellar: :any, x86_64_linux:      "2cfa448464efdd922dd7ac9df6d2fc59634978750d0194921f65c6b10a8516f6"
  end

  depends_on "rust" => :build # for jiter, polars, vl-convert
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "fzf"
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  pypi_packages package_name:     "mycli[llm,dataframe]",
                exclude_packages: %w[certifi cryptography pydantic],
                extra_packages:   %w[jeepney secretstorage]

  resource "altair" do
    url "https://files.pythonhosted.org/packages/e8/de/9731304fae332b5783fdc3ed18531dfaf4a3cc62a66aaaa74c047355b70f/altair-6.3.0.tar.gz"
    sha256 "fa632121aca6d0fcb198a3d8a9f7d937fa5b7518ec947951cfffb44e736d97c8"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/0e/9c/b52e0c1d6d15b16a98d5ddbeda318943f2c3638a9566f740aab251f1c3ad/cli_helpers-2.15.3.tar.gz"
    sha256 "fde47d1495e49897acd3e084d93600dba5885a79073b89ead14c40d28c610c19"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "clickdc" do
    url "https://files.pythonhosted.org/packages/c6/c6/bae77666e82b78efeb11f53adbffef757141d7c236ab933e522b469910b4/clickdc-0.1.1.tar.gz"
    sha256 "077f04d7ad00509b43aa8e37a9c7df307c00a73f7fef265235ef98ca54235b9b"
  end

  resource "condense-json" do
    url "https://files.pythonhosted.org/packages/d1/a5/7158b674fa5b890d80faaf42dd438d1a765661cd22430ddf499759cf44e1/condense_json-1.1.tar.gz"
    sha256 "c455b54bbbab89a69f598b09f2003a89b738df20d30e6aa341c495401ec5b349"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/c0/61/afa9d6b7452f9eca73f73d45324eb0bb52f098fd5e6049bf6b8263be9b4e/httpcore2-2.16.0.tar.gz"
    sha256 "c72cd0413563b17e1cd8354677dff887466f8ec2551679759e93126534428643"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/43/73/5ca2cedf5e4e50423d1c258877865a6b62793633b561c58499f8aeb33b7e/httpx2-2.16.0.tar.gz"
    sha256 "0d54c98128e8f2ff7fbbde0fca8c359e5f032edeaaaac443cdb7f31f685bcd7f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/6c/1f/c23395957d41ccf27c4e535c3d334c4051e5395b3752057ba4cbaec35c56/jaraco_functools-4.6.0.tar.gz"
    sha256 "880c577ec9720b3a052d5bc611fb9f2269b3d87902ef42440df443b88e443280"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/63/5b/f68319f4fe624311a744a33d10fdbcac4c971991e348223cba60d31780b2/jiter-0.18.0.tar.gz"
    sha256 "a0ca63fd9450a212e4e658d4cfe0ab4977c4f9b0003c68828b843c65e27662ff"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "llm" do
    url "https://files.pythonhosted.org/packages/fd/62/922539af45ed35ebd6de6dcd5676891e75a6c1e94e4d76ac0d2460bd6ad7/llm-0.37.1.tar.gz"
    sha256 "5c74c8dbeb404d18717a9724761dd1f70f36c3dc4176d4d33668f9e448369e29"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/52/b8/c63995bebbb9ac9c059350e0fb8c82c2420c85aeca7d34e40aecf3df9281/more_itertools-11.2.1.tar.gz"
    sha256 "cbf08fd0af284dc69718b9b76a8e6203df624d70209ea511e4219d350c856f63"
  end

  resource "narwhals" do
    url "https://files.pythonhosted.org/packages/67/43/e11d75a7fb635c6f63dd6e176cb3e050ec2fee35f2f2267b332a6ad351ec/narwhals-2.28.0.tar.gz"
    sha256 "2d9860c80d6610820826e94c6e42ce4b1d92d89cdd479586e652a8d211dab345"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/34/b6/23cddcb571d6eafe7b4bb58c7e0a068076121b7b001b776179994cca6a03/openai-3.46.0.tar.gz"
    sha256 "fb34cd8cab6809ad0aa8dc42493fa622aaa87c814fd8e67a6fb3fa1f1e5d952d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "polars" do
    url "https://files.pythonhosted.org/packages/b9/da/c27daf205a824f89f71172a75ad0098c5837a5a31ddeaac7f8737ea8574b/polars-2.1.0.tar.gz"
    sha256 "9eee488d6e10773c028753dfc8dac647fd60a708108dcb818a733e85d33df253"
  end

  resource "polars-runtime-32" do
    url "https://files.pythonhosted.org/packages/e0/a6/46e09af693326735b1fba3a8bf5a725b57136fb1342e707e75d3113c826b/polars_runtime_32-2.1.0.tar.gz"
    sha256 "c575f5f3cdb8a5f9be65477b9b4202b062593687fe62a0082add87fbd4571067"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/24/74/ce5987ab9b8aec4ced06e2723ebb604205c9eb58abdad91453da93166380/puremagic-2.2.0.tar.gz"
    sha256 "eb4bddf07c177c4b434554b92165b67449f5a51e152b976202d6254498810eef"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/f4/e7/50e72301e32acb73a314e663c2014e1ddefc019d5f434ff14ec89861d664/pycryptodomex-3.24.1.tar.gz"
    sha256 "09081666ffc599976c0b8b29caf2cf82212c0f05bed233c8f8ed53e4f6e1d356"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pymysql" do
    url "https://files.pythonhosted.org/packages/b1/d4/c15b459e25a23767d2f4065ef40968920320f04e302889574310c21c96a3/pymysql-1.2.3.tar.gz"
    sha256 "d5b288529782e536ae171866df3ca9dc4f6cbfb3cc2f18e6f837fbb90dbc262b"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/18/39/b3927f3616f6223832f9b760e4208e8a7c7e1dea2b4d9ad7d32a5d214c3a/python_dateutil-4.0.0.tar.gz"
    sha256 "d7295ff14fdc0f92f662100bfb6c551d160ca090f2939f1ec5b9794265c03f06"
  end

  resource "python-ulid" do
    url "https://files.pythonhosted.org/packages/50/a9/7d7e7e9a43c85c5d7efb44696c623612c5c0b87bdd9447292d0514a5bc59/python_ulid-4.1.0.tar.gz"
    sha256 "7991ae0b139eed37fd843be81d561c56ec2c7544ef78262a401cd1a31bc41021"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/18/97/226c43b7b5d957bc3840ed52ea99eed261f99834c4619be7a4742cbaeafa/rapidfuzz-3.14.6.tar.gz"
    sha256 "e13a8160d017b499ec7a2fa9d0ce1ae2e7377080815785819f966fb235d4eb60"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/42/68/3bd46b8a5e01d3c2ebdf9c5e9497912e3fe0cde02bac21a7130ca866e403/rpds_py-2026.9.1.tar.gz"
    sha256 "4793ef7f78268b124b73fa933440f01d258bbae01de9fa53e9080c9ab0425a12"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sqlglot" do
    url "https://files.pythonhosted.org/packages/ff/bd/3885516929bfea13c635d5721c468e664defe56a89c073ecf8640f5a5c8a/sqlglot-30.25.0.tar.gz"
    sha256 "d2d6e4d4865a210b1e33a801b105a6782ef12280cc2b6d0969bdc2634aef427a"
  end

  resource "sqlglotc" do
    url "https://files.pythonhosted.org/packages/24/c8/d2e141765c351a58c5c41e603917bd5fc69df21de7be25c28fff2013cfa6/sqlglotc-30.25.0.tar.gz"
    sha256 "d7eba1885ccb69a8a89d8a7f88ab515a9920ab94af461954370c609dbc1f6c3a"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/c2/6d/9dad6c3b433ab8912ace969c66abd595f8e0a2ccccdb73602b1291dbda29/sqlite-fts4-1.0.3.tar.gz"
    sha256 "78b05eeaf6680e9dbed8986bde011e9c086a06cb0c931b3cf7da94c214e8930c"
  end

  resource "sqlite-utils" do
    url "https://files.pythonhosted.org/packages/7e/6b/4a7b3d20c92e6c7acedc96ef620df8e1ea8f94a26a41ab788c1c08055815/sqlite_utils-4.2.1.tar.gz"
    sha256 "76114b6a5414714e6c70e5fa5c4781b301b590f6951b5da39c8cc60c21382ba1"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/7e/e0/361c764ea58cc1a75f7b4b424a74b08449db8bfa5e9199c7275999fdd1b9/sqlparse-0.6.1.tar.gz"
    sha256 "ca722573f848ff2d30e40ea30f53a104b7dea7635ea9285891263eb2c58fb6e7"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/46/79/cf31d7a93a8fdc6aa0fbb665be84426a8c5a557d9240b6239e9e11e35fc5/termcolor-3.3.0.tar.gz"
    sha256 "348871ca648ec6a9a983a13ab626c0acce02f515b9e1983332b17af7979521c5"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/ee/9f/c5201d42a484c061e528825fc8e2d565f5abd50a4ced6fb7d29c4ec99b2b/truststore-0.10.5.tar.gz"
    sha256 "30d36967ccaded5cbb38d602c433f53600036c79d502f4533a49b60a03bbefcd"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/7a/29/6a1391d31cd00ff9e927215a224a880e1e84e826b64ba80a499e51c074d8/tzdata-2026.6.tar.gz"
    sha256 "85d2cd9c09f81f0bb29db27759fc83af4f1e620efb814f8c5bf8b4cc4feece6d"
  end

  resource "vl-convert-python" do
    url "https://files.pythonhosted.org/packages/93/89/36722344d1758ec2106f4e8eca980f173cfe8f8d0358c1b77cc5d2e035a4/vl_convert_python-1.9.0.post1.tar.gz"
    sha256 "a5b06b3128037519001166f5341ec7831e19fbd7f3a5f78f73d557ac2d5859ef"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/ea/01/e5ac23733628a6bbb91913a765fcf55ee8070d8d991bc88fdaaf805052c7/wcwidth-0.9.4.tar.gz"
    sha256 "fd8d57d3cdfe570e3265c8fab1885c24e34ef40889c0759c0c304a19e9835954"
  end

  resource "yaspin" do
    url "https://files.pythonhosted.org/packages/37/20/4b44e31e5a1bfe09624267656dc02c31fe920e35e81697722dd45caac9f1/yaspin-3.5.1.tar.gz"
    sha256 "5cb55fb774eae3543fdd30b5958c46e348dfd316a8b289c9f8db2c6f8a511846"
  end

  def install
    # Work around superenv breaking aws-lc-sys `-O0` needed to build CPU Jitter RNG
    ENV["AWS_LC_SYS_NO_JITTER_ENTROPY"] = "1"

    without = %w[polars-runtime-32 sqlglotc]
    without += %w[jeepney secretstorage] unless OS.linux?
    venv = virtualenv_install_with_resources(without:)

    # sqlglotc must compile against our sqlglot, but `PIP_CONSTRAINT` does not reach its build env.
    resource("sqlglotc").stage do
      inreplace "pyproject.toml", "\n    \"sqlglot\",", "\n    \"sqlglot==#{resource("sqlglot").version}\","
      venv.pip_install Pathname.pwd
    end

    # polars enables its `nightly` feature by default, which needs a nightly compiler.
    # Disable LTO and debug info to reduce peak memory usage when linking the large extension.
    with_env(CARGO_PROFILE_RELEASE_DEBUG: "false",
             CARGO_PROFILE_RELEASE_LTO:   "false",
             MATURIN_PEP517_ARGS:         "--no-default-features --features full") do
      venv.pip_install resource("polars-runtime-32")
    end

    bash_completion.install "mycli/resources/completions/bash/mycli"
    fish_completion.install "mycli/resources/completions/fish/mycli.fish"
    zsh_completion.install "mycli/resources/completions/zsh/_mycli"
  end

  test do
    system bin/"mycli", "--help"
  end
end
