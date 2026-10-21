class Otterdog < Formula
  include Language::Python::Virtualenv

  desc "Manage GitHub organizations at scale using an infrastructure as code approach"
  homepage "https://otterdog.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/4c/9c/2bcc6edae61778a28333af98d91e60c7216b210326180aaa27fae11d4587/otterdog-1.6.1.tar.gz"
  sha256 "0bfabbceb9c923055a5d4bcb542f11c2ffa37bc73bc1addf22946f3b140c1426"
  license "EPL-2.0"
  head "https://github.com/eclipse-csi/otterdog.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "4c19192d1ae15ad89dfe8491a7ba7ee66dc1f3b0ac791670f7fd3e2583ded1da"
    sha256 cellar: :any, arm64_tahoe:       "b5018388ea5fb2a688b98300d70701050303b1bd686688ebaf6e95958f99b8ca"
    sha256 cellar: :any, arm64_sequoia:     "9ee3ef2567328a67d287fce759faf16f77c5612bcbf9dce6f43bdaa572efae4b"
    sha256 cellar: :any, arm64_linux:       "a199647f57a1c76f2344df1a696c0b898b445c824316cc8d7e20285af811a877"
    sha256 cellar: :any, x86_64_linux:      "a41d2fa74360feeb1a66c32557129daf1e654d08f2800ab53bcf1e0aa1706130"
  end

  depends_on "rust" => :build # for rjsonnet
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium"
  depends_on "node"
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: %w[certifi cryptography playwright rpds-py],
                extra_packages:   %w[greenlet pyee typing-extensions]

  # No sdist on PyPI, so we use the GitHub tarball
  # Ref: https://github.com/microsoft/playwright-python/issues/2579
  resource "playwright" do
    url "https://github.com/microsoft/playwright-python/archive/refs/tags/v1.62.0.tar.gz"
    sha256 "30cc72a0c00a22c3d287539233d3d6abd579becbfe7d02aef80bd3e75c951455"

    # We track poetry.lock version while PyPI sdist is not available as it
    # guarantees a compatible version is installed.
    livecheck do
      url "https://raw.githubusercontent.com/eclipse-csi/otterdog/refs/tags/v#{LATEST_VERSION}/poetry.lock"
      regex(/name = "playwright"\nversion = "(\d+(?:\.\d+)+)"/i)
    end
  end

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/0b/03/a88171e277e8caa88a4c77808c20ebb04ba74cc4681bf1e9416c862de237/aiofiles-24.1.0.tar.gz"
    sha256 "22a075c9e5a3810f0c2e48f3008c94d68c65d763b9b03857924c99e57355166c"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/6c/4c/bdccd81e9ee225b69c60e7766c9a5b05364f118f4d383713b89a682d772d/aiohttp-3.14.5.tar.gz"
    sha256 "5558a7f5a05af9ecf744af91e5baefc436f93c9333e656c27ec253f9a6bbe178"
  end

  resource "aiohttp-client-cache" do
    url "https://files.pythonhosted.org/packages/38/f1/2ee2ddb76920dd34fc2eba0ead58acb40c83e3e8bf0d42601aa17e318987/aiohttp_client_cache-0.15.0.tar.gz"
    sha256 "264fa7d69bcdb2e4fe9994e7f41ab5eec7cbba2a5f5e260d444d002f9626e374"
  end

  resource "aiohttp-retry" do
    url "https://files.pythonhosted.org/packages/9d/61/ebda4d8e3d8cfa1fd3db0fb428db2dd7461d5742cea35178277ad180b033/aiohttp_retry-2.9.1.tar.gz"
    sha256 "8eb75e904ed4ee5c2ec242fefe85bf04240f685391c4879d8f541d6028ff01f1"
  end

  resource "aioshutil" do
    url "https://files.pythonhosted.org/packages/d3/bd/dcea5abb1792269e70cc75d5f9ae9adbdfba0f0d08a207eb788ec3b469b6/aioshutil-1.6.tar.gz"
    sha256 "9eae342b9a4cacc2c2c5877877a2d2f7a2b66c62aa1ab57d7e95c8cfd4ede507"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/4e/8a/64761f4005f17809769d23e518d915db74e6310474e733e3593cfc854ef1/aiosqlite-0.22.1.tar.gz"
    sha256 "043e0bd78d32888c0a9ca90fc788b38796843360c855a7262a532813133a0650"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "asyncer" do
    url "https://files.pythonhosted.org/packages/95/e3/a9de31596d386b8e76e17c609e20775c6a414cff95d025551aca3c63f282/asyncer-0.0.18.tar.gz"
    sha256 "dc233a466f85f1bc17dafcdb861b06291b64777a8d9076f7884467cbb66f95ef"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "chevron" do
    url "https://files.pythonhosted.org/packages/15/1f/ca74b65b19798895d63a6e92874162f44233467c9e7c1ed8afd19016ebe9/chevron-0.14.0.tar.gz"
    sha256 "87613aafdf6d77b6a90ff073165a61ae5086e21ad49057aa0e53681601800ebf"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/6e/2d/6f6e649818da44d4499604802c89329b8d9799687a124e3a5e467a643336/gitpython-3.2.0.tar.gz"
    sha256 "fb92310af6844d96adc95ca066ed2e617c00e1dbd146a326626c81e72e18cc2e"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/3e/6e/0091f175ccd02b02bc8811bbcbcc6ac2e980be116e3b2f7a736ca322bf84/greenlet-3.5.6.tar.gz"
    sha256 "8e67c43bdfc88d5fee6db0d3e40175b362fc95fb85f0412d233b9b203c53a575"
  end

  resource "hvac" do
    url "https://files.pythonhosted.org/packages/e2/57/b46c397fb3842cfb02a44609aa834c887f38dd75f290c2fc5a34da4b2fee/hvac-2.4.0.tar.gz"
    sha256 "e0056ad9064e7923e874e6769015b032580b639e29246f5ab1044f7959c1c7e0"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/cf/8c/f834fbf984f691b4f7ff60f50b514cc3de5cc08abfc3295564dd89c5e2e7/importlib_resources-6.5.2.tar.gz"
    sha256 "185f87adef5bcc288449d98fb4fba07cea78bc036455dd44c5fc4a2fe78fed2c"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jsonata-python" do
    url "https://files.pythonhosted.org/packages/5b/e1/a1247412b909987479acc5e376c65f975a7daf25ec37e91cc0c8ec5fa74e/jsonata_python-0.7.1.tar.gz"
    sha256 "c3c4dd3e68d913cf079ed5374cfcc6b249fb33fedaef55b23b14c7168b797e4e"
  end

  resource "jsonbender" do
    url "https://files.pythonhosted.org/packages/33/ba/b89ab7fb6127eda78e6351568a80cb1e45c5c2c87c3e96df6e6e5a922b43/JSONBender-0.9.3.tar.gz"
    sha256 "54c0503f9e2f9768b113c12ef3d9502da14f0c434853a515cbc9c20e21572538"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mintotp" do
    url "https://files.pythonhosted.org/packages/c0/b4/126c898d8bdd6d73ee702cf221ab8ddfb8c53db9bc101272542e478eba20/mintotp-0.3.0.tar.gz"
    sha256 "d0f4db5edb38a7481120176a526e8c29539b9e80581dd2dcc1811557d77cfad5"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/f9/79/84ddb5ba16c4eb2c69c71db76ae3c579fe546e511f7170c7e27eedbab7c1/multidict-7.1.0.tar.gz"
    sha256 "61a4e5d81b8d4e4ad61964b230129e7a2b914793d96289029078fc9009f074ec"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/b3/9a/9fbf4e4ec0c2d7f1c32519fff782ef467859b8faa9fbc5331a96f6395d43/propcache-0.5.4.tar.gz"
    sha256 "ff6b113f50bc066a698db5d944d2c6dc7507168dd3341e255a8892fd0715a558"
  end

  resource "pyee" do
    url "https://files.pythonhosted.org/packages/8b/04/e7c1fe4dc78a6fdbfd6c337b1c3732ff543b8a397683ab38378447baa331/pyee-13.0.1.tar.gz"
    sha256 "0b931f7c14535667ed4c7e0d531716368715e860b988770fc7eb8578d1f67fc8"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/43/ea/5194e52748b0da83d71e082d75496eaec6e58f419f5e184786ded517e6a9/pyjwt-2.15.1.tar.gz"
    sha256 "4f259e80cdfb6b3fc18a7de51fd1ef9ec79652f25019bae68975ca2468a34df8"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "rjsonnet" do
    url "https://files.pythonhosted.org/packages/70/65/4c6b1e4baf48ebbc6ff0c8cf8b50f08c63173d9abd5dd7f3af03b4bcd460/rjsonnet-0.5.6.tar.gz"
    sha256 "47bd8f63b4b1def67f83001c07ff7d43d6a90dbf89cb6fb680c941db809a60ce"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "url-normalize" do
    url "https://files.pythonhosted.org/packages/33/26/b60cce0211e94bb130e88dbcba87583f61c6ddf386fa6adc10a167461f6a/url_normalize-3.0.1.tar.gz"
    sha256 "1655cd214159d9d47dc37aa6ce993c2149da44fa35cac6bafd90036a4eda3ac3"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/75/16/e8be8e2fb175bbf41a0680381a319f1199fae256588241a2ac8677eafb49/yarl-1.25.1.tar.gz"
    sha256 "03dd38de09bc213e9a8b29761eec33ee1d5318dac0e49d8af36e4d27830e23a7"
  end

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION_FOR_PLAYWRIGHT"] = resource("playwright").version
    venv = virtualenv_install_with_resources

    generate_completions_from_executable(bin/"otterdog", shell_parameter_format: :click)

    # Help find playwright when installed inside virtualenv
    rm(bin/name)
    (bin/name).write_env_script libexec/"bin"/name, PATH: "#{libexec}/bin:${PATH}"

    # Replace bundled node
    bundled_node = venv.site_packages/"playwright/driver/node"
    rm(bundled_node)
    ln_sf (formula_opt_bin("node")/"node").relative_path_from(bundled_node.dirname), bundled_node
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/otterdog --version")

    assert_match "No configuration file specified", shell_output("#{bin}/otterdog validate 2>&1", 2)
  end
end
