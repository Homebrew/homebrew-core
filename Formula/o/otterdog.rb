class Otterdog < Formula
  include Language::Python::Virtualenv

  desc "Manage GitHub organizations at scale using an infrastructure as code approach"
  homepage "https://otterdog.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/a0/04/7618d47fefde37040be3601c9facf062dbd4d7c0f915beec9a3ca126734b/otterdog-1.2.0.tar.gz"
  sha256 "74714601e8c0f011d480f22cccb94523f95442e370276ebde1bcd0e0dadfe7fa"
  license "EPL-2.0"
  head "https://github.com/eclipse-csi/otterdog.git", branch: "main"

  no_autobump! because: "'playwright' resource lacks PyPI sdist"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a3dbb6b0ce3524730d181ae87da2396e1c147249eacfb653e2a8d7dd115b6443"
    sha256 cellar: :any,                 arm64_sequoia: "6ccb5b53e76bdd6f3bd5c55e2e5c205a80eafc9a2d5bc5fb6bdf63de43587358"
    sha256 cellar: :any,                 arm64_sonoma:  "d44a2941665aac24970c5c414ce4fe0184471712fef7fea55cd5f53b7de67a8b"
    sha256 cellar: :any,                 sonoma:        "1878a14cb648d7012fdae6609d0979963f7e4cc7720c0bb75248b15b910487b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27b71e73b5370897a7f21135310dc78fa079c02551b3865213d52e4d38ee6587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f1d835b81f4118549945b3d458979d14f6ea7582d7cb6509331072ba79db249"
  end

  depends_on "rust" => :build # for rjsonnet
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: %w[certifi cryptography playwright rpds-py],
                extra_packages:   %w[greenlet pyee typing-extensions]

  # No sdist on PyPI, so we use the GitHub tarball
  # Ref: https://github.com/microsoft/playwright-python/issues/2579
  resource "playwright" do
    url "https://github.com/microsoft/playwright-python/archive/refs/tags/v1.56.0.tar.gz"
    sha256 "906f858568c32ddd6a6fbaef8fad182eb10ed2c972abf508c2a3f45945fa3768"
  end

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/0b/03/a88171e277e8caa88a4c77808c20ebb04ba74cc4681bf1e9416c862de237/aiofiles-24.1.0.tar.gz"
    sha256 "22a075c9e5a3810f0c2e48f3008c94d68c65d763b9b03857924c99e57355166c"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/50/42/32cf8e7704ceb4481406eb87161349abb46a57fee3f008ba9cb610968646/aiohttp-3.13.3.tar.gz"
    sha256 "a949eee43d3782f2daae4f4a2819b2cb9b0c5d3b7f7a927067cc84dafdbb9f88"
  end

  resource "aiohttp-client-cache" do
    url "https://files.pythonhosted.org/packages/40/21/070849a673103328285964419caa12de583229bbcd3552e73799b4ca86d0/aiohttp_client_cache-0.14.3.tar.gz"
    sha256 "329f4038c6a8ed0b410023980b6d1a2c484af33e667a89ce245c899d62c1fba1"
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
    url "https://files.pythonhosted.org/packages/96/f0/5eb65b2bb0d09ac6776f2eb54adee6abe8228ea05b20a5ad0e4945de8aac/anyio-4.12.1.tar.gz"
    sha256 "41cfcc3a4c85d3f05c932da7c26d0201ac36f72abd4435ba90d0464a3ffed703"
  end

  resource "asyncer" do
    url "https://files.pythonhosted.org/packages/33/26/9247244da7fe779e76fe9b9fc2bef7d6d57249cf9b925cb9992580c14358/asyncer-0.0.13.tar.gz"
    sha256 "f750abc10f17a1e4aa73862ba89d880fcf7bea683d9481020c992c26699b14f0"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "chevron" do
    url "https://files.pythonhosted.org/packages/15/1f/ca74b65b19798895d63a6e92874162f44233467c9e7c1ed8afd19016ebe9/chevron-0.14.0.tar.gz"
    sha256 "87613aafdf6d77b6a90ff073165a61ae5086e21ad49057aa0e53681601800ebf"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
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
    url "https://files.pythonhosted.org/packages/df/b5/59d16470a1f0dfe8c793f9ef56fd3826093fc52b3bd96d6b9d6c26c7e27b/gitpython-3.1.46.tar.gz"
    sha256 "400124c7d0ef4ea03f7310ac2fbf7151e09ff97f2a3288d64a440c584a29c37f"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/8a/99/1cd3411c56a410994669062bd73dd58270c00cc074cac15f385a1fd91f8a/greenlet-3.3.1.tar.gz"
    sha256 "41848f3230b58c08bb43dee542e74a2a2e34d3c59dc3076cec9151aeeedcae98"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
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
    url "https://files.pythonhosted.org/packages/b9/45/7f095befed14d95db05d56a1164b9e2c41d87faefad7277454e4fd3b2daf/jsonata_python-0.6.1.tar.gz"
    sha256 "416a65731f31f7cf427f3711bb1bf9117174985f9795e198020cce1a38d32984"
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

  resource "jwt" do
    url "https://files.pythonhosted.org/packages/7f/20/21254c9e601e6c29445d1e8854c2a81bdb554e07a82fb1f9846137a6965c/jwt-1.4.0.tar.gz"
    sha256 "f6f789128ac247142c79ee10f3dba6e366ec4e77c9920d18c1592e28aa0a7952"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
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
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/9e/da/e9fc233cf63743258bff22b3dfa7ea5baef7b5bc324af47a0ad89b8ffc6f/propcache-0.4.1.tar.gz"
    sha256 "f48107a8c637e80362555f37ecf49abe20370e557cc4ab374f04ec4423c97c3d"
  end

  resource "pyee" do
    url "https://files.pythonhosted.org/packages/95/03/1fd98d5841cd7964a27d729ccf2199602fe05eb7a405c1462eb7277945ed/pyee-13.0.0.tar.gz"
    sha256 "b391e3c5a434d1f5118a25615001dbc8f669cf410ab67d04c4d4e07c55481c37"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
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
    url "https://files.pythonhosted.org/packages/44/cd/a040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3b/smmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "url-normalize" do
    url "https://files.pythonhosted.org/packages/80/31/febb777441e5fcdaacb4522316bf2a527c44551430a4873b052d545e3279/url_normalize-2.2.1.tar.gz"
    sha256 "74a540a3b6eba1d95bdc610c24f2c0141639f3ba903501e61a52a8730247ff37"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/57/63/0c6ebca57330cd313f6102b16dd57ffaf3ec4c83403dcb45dbd15c6f3ea1/yarl-1.22.0.tar.gz"
    sha256 "bebf8557577d4401ba8bd9ff33906f1376c877aa78d1fe216ad01b4d6745af71"
  end

  def install
    # hatch does not support a SOURCE_DATE_EPOCH before 1980.
    # Remove after https://github.com/pypa/hatch/pull/1999 is released.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION_FOR_PLAYWRIGHT"] = resource("playwright").version
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"otterdog", shell_parameter_format: :click)

    # Help find playwright when installed inside virtualenv
    rm(bin/name)
    (bin/name).write_env_script libexec/"bin"/name, PATH: "#{libexec}/bin:${PATH}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/otterdog --version")

    assert_match "No configuration file specified", shell_output("#{bin}/otterdog validate 2>&1", 2)
  end
end
