class DepScan < Formula
  include Language::Python::Virtualenv

  desc "Security and risk audit tool for project dependencies and container images"
  homepage "https://github.com/owasp-dep-scan/dep-scan"
  url "https://files.pythonhosted.org/packages/31/ae/8835e551a4acb07e2e8513211ad2ca501f6654b96d9887238c9c6889d4ec/owasp_depscan-6.3.1.tar.gz"
  sha256 "b7bd36f9fb83be60838704dbb474a61623c199535140178e5004c7832e861017"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a2f02aefe46263f8126c6a019c68e584c328bdbd1eef594d20d553fb7c985413"
    sha256 cellar: :any, arm64_tahoe:       "6baf48d9be138eac769017f45d696ef5593822b1b4734bfe3de3688ae39bbf55"
    sha256 cellar: :any, arm64_sequoia:     "e8a1433e5e78032a2f1ffde5d02fbfdbf1b50ff07beda4aee95e11cfbc37c516"
    sha256 cellar: :any, arm64_linux:       "3e74d360d2372721a5bbeee59b706d7bcadee85948b56b5de2be4080ae366303"
    sha256 cellar: :any, x86_64_linux:      "1336c6c7f16792d6643285b00196919f8e20e322cf6d420dfc143300721982cc"
  end

  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage
  depends_on "sqlite" # APSW needs a newer version of SQLite than what macOS ships with.

  pypi_packages package_name:     "owasp-depscan[server]",
                exclude_packages: %w[certifi pydantic rpds-py]

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/41/c3/534eac40372d8ee36ef40df62ec129bee4fdb5ad9706e58a29be53b2c970/aiofiles-25.1.0.tar.gz"
    sha256 "a8d728f0a29de45dc521f18f07297428d56992a742f0cd2701ba86e44d23d5b2"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "appthreat-vulnerability-db" do
    url "https://files.pythonhosted.org/packages/fa/a8/4513a9c3ddf51c2958c930a6cc1ba97797fbf08066bb414eb7d70970265d/appthreat_vulnerability_db-6.7.6.tar.gz"
    sha256 "bb849c56c61d28a1df1258f5803830550bb449dc5d268dd762491db97245a800"
  end

  resource "apsw" do
    url "https://files.pythonhosted.org/packages/84/75/be84a7237ea1af8374c67ff7468053bff538e1591526805c6574b2efef4d/apsw-3.54.1.0.tar.gz"
    sha256 "d9fd64ed76dc0f3d2265d4aeedb74d678c2ac7dffbd4e8ba05bf9a87aa7c34d3"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "custom-json-diff" do
    url "https://files.pythonhosted.org/packages/b6/f9/670514efaceb028f739106231acfae1813638387742e130cd5561949c10e/custom_json_diff-2.1.6.tar.gz"
    sha256 "26d62a7f2fc61327c3bcda00b65d820f503682f242afcb1d2305186f8745e10e"
  end

  resource "cvss" do
    url "https://files.pythonhosted.org/packages/a5/f6/1f7d315de23f39bbc32b94bb6b33a1b6124856037bfaa3f8bdb1a49584fa/cvss-3.6.tar.gz"
    sha256 "f21d18224efcd3c01b44ff1b37dec2e3208d29a6d0ce6c87a599c73c21ee1a99"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/76/49/900383b471c645a3c397f47b3211d1fcecb3a540c98f683494cdf86b33de/dnspython-2.9.2.tar.gz"
    sha256 "8d4d39a513e649d634004ce4d39ade2352efcea472a0247535a5c2d18a9d7ba9"
  end

  resource "ds-analysis-lib" do
    url "https://files.pythonhosted.org/packages/e6/ec/d95d3e31958f3b357e45e525ae2f05c33a77dd9b9068d018c675e932c1af/ds_analysis_lib-6.3.1.tar.gz"
    sha256 "eb24db1167111a4644be25c7dd2f7f3156990958d86b62f36db0efbf5a52f9f5"
  end

  resource "ds-reporting-lib" do
    url "https://files.pythonhosted.org/packages/d0/aa/d6ed96b1c3ab18912e23fb27aa1f2284de6fd5ad09fc6bb7560266892f25/ds_reporting_lib-6.3.1.tar.gz"
    sha256 "a79f99d15890fedd6c87ec3a1c73e5644990b05f01109c96774baea94764d8c9"
  end

  resource "ds-server-lib" do
    url "https://files.pythonhosted.org/packages/c4/c6/781c4de56f07a82945f523f00db710e4755d0eb86b5e7945f5de0355b21e/ds_server_lib-6.3.1.tar.gz"
    sha256 "f9e41739b739804e7ea90235fd1ff34c9f0e67d4d87468662cc777fc5e21976e"
  end

  resource "ds-xbom-lib" do
    url "https://files.pythonhosted.org/packages/0e/9b/2249812cd747ca03fd1eec84337fad5c3a8c089cbdb60332bddc41e64af5/ds_xbom_lib-6.3.1.tar.gz"
    sha256 "209bd8f1dfdd6c0e4c7131f8da2ea6568c1472a283eb532b7e0dd7f6ea3d7554"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/f5/22/900cb125c76b7aaa450ce02fd727f452243f2e91a61af068b40adba60ea9/email_validator-2.3.0.tar.gz"
    sha256 "9fc05c37f2f6cf439ff414f8fc46d917929974a82244c20eb10231ba60c54426"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/26/00/35d85dcce6c57fdc871f3867d465d780f302a175ea360f62533f12b27e2b/flask-3.1.3.tar.gz"
    sha256 "0ef0e52b8a9cd932855379197dd8f94047b359ca0a78695144304cb45f87c9eb"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/e7/85/7c366e69d84c17bb778fe41419e1fbcce3033d5b7ce29bbffff0a98b859f/h2-4.4.1.tar.gz"
    sha256 "4e866ffb1a869ae14dd9b5e6beb5c24a13da0495ad72b65925ded182521c1516"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/26/5b/fcabf6028144a8723726318b07a32c2f3314acdff6265743cf08a344b18e/hpack-4.2.0.tar.gz"
    sha256 "0895cfa3b5531fc65fe439c05eb65144f123bf7a394fcaa56aa423548d8e45c0"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "hypercorn" do
    url "https://files.pythonhosted.org/packages/44/01/39f41a014b83dd5c795217362f2ca9071cf243e6a75bdcd6cd5b944658cc/hypercorn-0.18.0.tar.gz"
    sha256 "d63267548939c46b0247dc8e5b45a9947590e35e64ee73a23c074aa3cf88e9da"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/02/e7/94f8232d4a74cc99514c13a9f995811485a6903d48e5d952771ef6322e30/hyperframe-6.1.0.tar.gz"
    sha256 "f630908a00854a7adeabd6382b43923a4c4cd4b821fcb527e6ab9e15382a3b08"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "json-flatten" do
    url "https://files.pythonhosted.org/packages/a1/06/e6a7046e71488a899a990206dc2426e8b9192ab7a341bb95a75ac1c88922/json_flatten-0.3.1.tar.gz"
    sha256 "70e813acf431b1ab7e9eb7b98f5733d307d6b9d27b553a344904b9c8eafdad3a"
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

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "oras" do
    url "https://files.pythonhosted.org/packages/c5/d2/dc4a3eb07ac779455dbfbc85cd396025ad72450ed7673a323c685cfb6774/oras-0.2.43.tar.gz"
    sha256 "761f2b518fce50e5e9482975363ff0230f63fc65f84c09510fbcc301782a047c"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/f2/72/380b97dc45bd162d23afe5194721ef678d9eac7cfaa549fe2873f7f0a518/orjson-3.13.0.tar.gz"
    sha256 "d1de5eb04485110c5da4c657e49168995d55e076b1ce60f1a042e254f4186c4f"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/f5/d6/3b5a4e3cfaef7a53869a26ceb034d1ff5e5c27c814ce77260a96d50ab7bb/packageurl_python-0.17.6.tar.gz"
    sha256 "1252ce3a102372ca6f86eb968e16f9014c4ba511c5c37d95a7f023e2ca6e5c25"
  end

  resource "priority" do
    url "https://files.pythonhosted.org/packages/f5/3c/eb7c35f4dcede96fca1842dac5f4f5d15511aa4b52f3a961219e68ae9204/priority-2.0.0.tar.gz"
    sha256 "c965d54f1b8d0d0b19479db3924c7c36cf672dbf2aec92d43fbdaf4492ba18c0"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "quart" do
    url "https://files.pythonhosted.org/packages/6b/81/34396f67e09e7a0609261f1ef0f43b26f5d67e8f2dc4d34b4953061560f2/quart-0.23.1.tar.gz"
    sha256 "1ca848415910bd2eb75e9d9b452388f892a37be222602a373622e6c633d1efbf"
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
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/92/f5/e1dfe8e1d91c54ce212fd93916eb01fd1c590f413be0a0978c39a97aa1bb/semver-3.1.0.tar.gz"
    sha256 "14bc073439513d7773662a338f4db9829cf16c12b74b9568e2d2689975fbd7fc"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/a4/34/4dd12fc8bb7d61c91467ec3efe415ffa7d5456f799954b40c5bbaeae470e/werkzeug-3.1.9.tar.gz"
    sha256 "55ca7c70a75689be937aa27f8ff4b018f06ff4838fc73045560bf0f5a1291060"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/c7/79/12135bdf8b9c9367b8701c2c19a14c913c120b882d50b014ca0d38083c2c/wsproto-1.3.2.tar.gz"
    sha256 "b86885dcf294e15204919950f666e06ffc6c7c114ca900b060d6e16293528294"
  end

  resource "homebrew-demo-bom", :test do
    url "https://raw.githubusercontent.com/owasp-dep-scan/dep-scan/e83b019078932489fc7d9b90991c6b046ba705bb/packages/analysis-lib/tests/data/vex/demo_bom.json"
    sha256 "078be839bc1458dfcbe8557d08898e514ce119d9e3409eb6e0c0b22caeb28069"
  end

  deny_network_access! :test

  def install
    venv = virtualenv_install_with_resources without: "apsw"
    resource("apsw").stage do
      # Use the brewed SQLite library instead of downloading and building one.
      # https://github.com/rogerbinns/apsw/blob/master/doc/install.rst#advice-for-packagers
      rm "setup.apsw"
      (buildpath/"setup.apsw").write <<~INI
        [build_ext]
        use_system_sqlite_config = True
      INI
      venv.pip_install Pathname.pwd
    end
  end

  service do
    run [opt_bin/"depscan", "--server"]
    environment_variables PATH: std_service_path_env
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depscan --version")

    ENV["VDB_HOME"] = testpath/"vdb"
    # A fresh timestamp stops depscan downloading its large vulnerability database.
    (testpath/"vdb/vdb.meta").write({ created_utc: Time.now.utc.iso8601 }.to_json)

    resource("homebrew-demo-bom").stage testpath
    args = %w[--no-banner --bom=demo_bom.json --reports-dir=reports]
    system bin/"depscan", *args
    refute_match "CVE-2024-20002", (testpath/"reports/depscan.txt").read

    # The demo BOM lists `CVE-2024-20002` for `left-pad@1.3.0` but depscan only
    # reports advisories from its database, so provide it as custom data.
    # CVE records identify the assigning organisation by a v4 UUID.
    org_id = "00000000-0000-4000-8000-000000000000"
    (testpath/"custom/CVE-2024-20002.json").write({
      dataType:    "CVE_RECORD",
      dataVersion: "5.2",
      cveMetadata: { cveId: "CVE-2024-20002", assignerOrgId: org_id, state: "PUBLISHED" },
      containers:  {
        cna: {
          providerMetadata: { orgId: org_id },
          descriptions:     [{ lang: "en", value: "Homebrew test advisory" }],
          affected:         [{ packageURL: "pkg:npm/left-pad" }],
        },
      },
    }.to_json)
    system bin/"depscan", *args, "--custom-data=custom"
    assert_match "CVE-2024-20002", (testpath/"reports/depscan.txt").read
  end
end
