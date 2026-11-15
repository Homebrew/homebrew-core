class Harlequin < Formula
  include Language::Python::Virtualenv

  desc "Easy, fast, and beautiful database client for the terminal"
  homepage "https://harlequin.sh", browsed: "2026-09-05"
  url "https://files.pythonhosted.org/packages/c6/0c/d2f0eaf8ca5b6d1e484906013e3670838891ec286cf064f2f04bd9e19e55/harlequin-2.17.0.tar.gz"
  sha256 "2e129308168a72e71c336c5679978a5385efb89d32507d3e1d6e1f773ee6dda1"
  license "MIT"
  head "https://github.com/tconbeer/harlequin.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "991e65115a82cf7a8492f3c7728ff1e360f534cd5bc852bc247ef7317a45c924"
    sha256 cellar: :any, arm64_tahoe:       "cafa0f170a7f2acc4108410cf0e9aee4d49a33f068b9836d397a4a6d3ed5d144"
    sha256 cellar: :any, arm64_sequoia:     "62071d2e9d49cb11e8c06e76c8ed94440d3d420ebc4f2b5fedd4294565f459ec"
    sha256 cellar: :any, arm64_linux:       "90bec23ab073fb2248cfd7e8825ca4a54c1233a19b0846e1fac97a1a3ac23a6c"
    sha256 cellar: :any, x86_64_linux:      "c46b3a044485781bf5831e33f6907839512b23564098a5d6bf3628f436610e73"
  end

  depends_on "cmake" => :build
  depends_on "libyaml" => :build # pyarrow > pyyaml
  depends_on "ninja" => :build
  depends_on "rust" => :build # pyarrow > libcst
  depends_on "apache-arrow"
  depends_on "libpq" # psycopg
  depends_on "numpy" => :no_linkage
  depends_on "python@3.15"
  depends_on "unixodbc" # harlequin-odbc

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  pypi_packages package_name:     "harlequin[mysql,odbc,postgres]",
                exclude_packages: %w[numpy psycopg-binary tree-sitter-languages]

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "duckdb" do
    url "https://files.pythonhosted.org/packages/c2/7c/dfdf5e9cebefd032f57f09b224993e861ecb55f61e36c709544b04b44f70/duckdb-2.0.0.tar.gz"
    sha256 "09de511ef0dc76a5213e8d3d87a8b89bb4d3e8a6fe73a9f60dc001269946b44f"
  end

  resource "harlequin-mysql" do
    url "https://files.pythonhosted.org/packages/f2/34/e0b31d86cc318c2df15e01d7420681b3f4f1fe49ec8a3c6215ca113e1bef/harlequin_mysql-1.5.0.tar.gz"
    sha256 "84ab123f74ac1e9fcfcda486b842401f0ee9e42acde3dd1d6d4da7c0f844211c"
  end

  resource "harlequin-odbc" do
    url "https://files.pythonhosted.org/packages/c1/1b/e5bc547d98771ce87a8c5ef3c96908e93c95406b50462085a3ebfcd2f86d/harlequin_odbc-0.4.0.tar.gz"
    sha256 "98356c5ebaacc23daff35e165d4490e1ea10dc591fa9cb0824f41272b39d13f0"
  end

  resource "harlequin-postgres" do
    url "https://files.pythonhosted.org/packages/63/19/09937776647585e0e9bb58f8f99d63159ad1b32bc52cf096fccf263806b7/harlequin_postgres-1.6.0.tar.gz"
    sha256 "48608904f81622493ff24f705b945ee4ff95c7b315d5c9fc81d9058204bc2104"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/45/98/7a1a5f31fd5c7ba93e963b168e244b8e3dd705b3d2a718e3c3307583bf57/linkify_it_py-2.2.0.tar.gz"
    sha256 "907acd2d17ac1fbb9ddb62c8957ccbd6158cac602231a15c3b0cd1e215f03cee"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/59/fc/f8d0863f8862f25602c0404d75568e89fb6b4109804645e5cdfb1be5cf56/mdit_py_plugins-0.6.1.tar.gz"
    sha256 "a2bca0f039f39dbd35fb74ae1b5f998608c437463371f0ff7f49a19a17a114d0"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgspec" do
    url "https://files.pythonhosted.org/packages/d0/e6/6dcf9306ff3c5e486578f3bf29ed11dfbdbbc2a8bf0caf7e07d392887fda/msgspec-0.22.0.tar.gz"
    sha256 "0a13624a4969159fe35d8c2a3d377b2b61bbd8585e327440d5e52725affcce38"
  end

  resource "mysql-connector-python" do
    url "https://files.pythonhosted.org/packages/26/c9/a9446dbebbcdf7d828d0a3be9049607eab6eeffb4e46ef1ee8ac304baede/mysql_connector_python-9.7.0.tar.gz"
    sha256 "933887e71c871b6e9d8908459fe8303ebcf8feb5cc1e1c49caa6490e525cf78e"

    # Apply Fedora patch to support OpenSSL 4 / Python 3.15
    # https://src.fedoraproject.org/rpms/mysql-connector-python/blob/rawhide/f/mysql-connector-python-python315-ssl.patch
    patch :p2 do
      file "Patches/mysql-connector-python/mysql-connector-python-python315-ssl.patch"
      type :unofficial
    end
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/40/28/1c058a9143d2304b3078f8dadcbb9dc27f7d3581b5d05157c84869c4cc0d/platformdirs-4.14.0.tar.gz"
    sha256 "83f009c1e8c5fc36869b5171755b291887bd2cade7965233cdfabd23d754720b"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/76/26/3ea4ca5eaea1c0debcdf7ee7c1613fbe721dc27a03c461c0817ffd8a0601/psycopg-3.3.6.tar.gz"
    sha256 "c081f2250df751a943036e42db6df4571c66cd0aabe8291a7a506512b12007d2"
  end

  resource "psycopg-pool" do
    url "https://files.pythonhosted.org/packages/74/5e/c0664b968b102ff68b811d999c728546c48d5c1eec03e3bbaf88c0cb4472/psycopg_pool-3.3.3.tar.gz"
    sha256 "df87b5d9d0ad7db37f6cdad4fa8ce113d250f5997f6db38e9a99192fb67f9e1d"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/ec/34/17c34cb38e5d940e38f0f0d9fdfa0e8a506676409ea9b85aff7e3079f831/pyarrow-26.0.0.tar.gz"
    sha256 "0cccd36e00ea3afeb52ded61f2721ce71f604853d70c45365c58324eb773d6ae"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyodbc" do
    url "https://files.pythonhosted.org/packages/8f/85/44b10070a769a56bd910009bb185c0c0a82daff8d567cd1a116d7d730c7d/pyodbc-5.3.0.tar.gz"
    sha256 "2fe0e063d8fb66efd0ac6dc39236c4de1a45f17c33eaded0d553d21c199f4d05"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/f6/45/eafb0bba0f9988f6a2520f9ca2df2c82ddfa8d67c95d6625452e97b204a5/questionary-2.1.1.tar.gz"
    sha256 "3d7e980292bb0107abaa79c68dd3eee3c561b83a0f89ae482860b181c8bd412d"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-click" do
    url "https://files.pythonhosted.org/packages/96/3e/5688fdd83aea416de336582a274f2bc8236b5c261b04c11e17bc262786ad/rich_click-1.9.9.tar.gz"
    sha256 "324cba7513cd4187ee92b2eef21f071714e45be062458c8b157bd7e0c81103e3"
  end

  resource "shandy-sqlfmt" do
    url "https://files.pythonhosted.org/packages/18/61/29e13aa8c39da9fe821fb393c4113b166517a38d8a2bb53142c9b6dd0892/shandy_sqlfmt-0.32.0.tar.gz"
    sha256 "f1e93928659f8159e399f189050b60dbe2135812eccfc1566b04644fb0dc3304"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/00/21/39a76b01bd5eea82a04baaca7580e105d8c59450df03998345bb2cfb307b/textual-8.2.8.tar.gz"
    sha256 "3f106a9fbc73e39dd266c9712432087de78a6d644084c7c241d6a25c3169115b"
  end

  resource "textual-fastdatatable" do
    url "https://files.pythonhosted.org/packages/f8/d7/53a2950fe3ce9c6d7f07961359ef34d510929a4bd7e30a0bc7ded888b9db/textual_fastdatatable-0.19.3.tar.gz"
    sha256 "3b76a82c3a0637e29f603ca9d952393a7a6a7ec1a6ebc5e2a698beb1b233dfee"
  end

  resource "textual-textarea" do
    url "https://files.pythonhosted.org/packages/f6/35/abb09e482584e1ee69de2fc9caf9936e448d1386367bcc4540b7279fe4f1/textual_textarea-0.18.5.tar.gz"
    sha256 "21b5c700aee4cdd15c639e09edd737a62da026a138931c1f921c0805a6438967"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/08/72/fc01563df95c189a9f65850096bdc205bc2fe37da6c740cd64afaf18d07e/tomlkit-0.15.2.tar.gz"
    sha256 "83e32755ba1d20d9340bd069ee97e9f6232ba2346b63ffcba425de01f7e327a6"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/f7/03/5600b84aff2e6c4fe80cfebb4063fe2f50299521befe5f6092ab8c082f4a/tree_sitter-0.26.0.tar.gz"
    sha256 "b40c219edccc4564530c96f8f1556f6202b37cda964d1cbd7bd2b7e68b40a245"
  end

  resource "tree-sitter-bash" do
    url "https://files.pythonhosted.org/packages/8e/0e/f0108be910f1eef6499eabce517e79fe3b12057280ed398da67ce2426cba/tree_sitter_bash-0.25.1.tar.gz"
    sha256 "bfc0bdaa77bc1e86e3c6652e5a6e140c40c0a16b84185c2b63ad7cd809b88f14"
  end

  resource "tree-sitter-css" do
    url "https://files.pythonhosted.org/packages/38/37/7d60171240d4c5ba330f05b725dfb5e5fd5b7cbe0aa98ef9e77f77f868f5/tree_sitter_css-0.25.0.tar.gz"
    sha256 "2fc996bf05b04e06061e88ee4c60837783dc4e62a695205acbc262ee30454138"
  end

  resource "tree-sitter-go" do
    url "https://files.pythonhosted.org/packages/01/05/727308adbbc79bcb1c92fc0ea10556a735f9d0f0a5435a18f59d40f7fd77/tree_sitter_go-0.25.0.tar.gz"
    sha256 "a7466e9b8d94dda94cae8d91629f26edb2d26166fd454d4831c3bf6dfa2e8d68"
  end

  resource "tree-sitter-html" do
    url "https://github.com/tree-sitter/tree-sitter-html/archive/refs/tags/v0.23.2.tar.gz"
    sha256 "21fa4f2d4dcb890ef12d09f4979a0007814f67f1c7294a9b17b0108a09e45ef7"
  end

  resource "tree-sitter-java" do
    url "https://github.com/tree-sitter/tree-sitter-java/archive/refs/tags/v0.23.5.tar.gz"
    sha256 "cb199e0faae4b2c08425f88cbb51c1a9319612e7b96315a174a624db9bf3d9f0"
  end

  resource "tree-sitter-javascript" do
    url "https://files.pythonhosted.org/packages/59/e0/e63103c72a9d3dfd89a31e02e660263ad84b7438e5f44ee82e443e65bbde/tree_sitter_javascript-0.25.0.tar.gz"
    sha256 "329b5414874f0588a98f1c291f1b28138286617aa907746ffe55adfdcf963f38"
  end

  resource "tree-sitter-json" do
    url "https://github.com/tree-sitter/tree-sitter-json/archive/refs/tags/v0.24.8.tar.gz"
    sha256 "acf6e8362457e819ed8b613f2ad9a0e1b621a77556c296f3abea58f7880a9213"
  end

  resource "tree-sitter-markdown" do
    url "https://files.pythonhosted.org/packages/10/ee/d54192a828a931082bcb4f71d4e66369318ae8fb0f30758ade716c6c92fb/tree_sitter_markdown-0.5.4.tar.gz"
    sha256 "5fc422637d41aa5b286551a8e6fa674733d92dac1c6a42c1d4ada0be59045bd3"
  end

  resource "tree-sitter-python" do
    url "https://files.pythonhosted.org/packages/b8/8b/c992ff0e768cb6768d5c96234579bf8842b3a633db641455d86dd30d5dac/tree_sitter_python-0.25.0.tar.gz"
    sha256 "b13e090f725f5b9c86aa455a268553c65cadf325471ad5b65cd29cac8a1a68ac"
  end

  resource "tree-sitter-regex" do
    url "https://files.pythonhosted.org/packages/86/92/1767b833518d731b97c07cf616ea15495dcc0af584aa0381657be4ec446d/tree_sitter_regex-0.25.0.tar.gz"
    sha256 "5d29111b3f27d4afb31496476d392d1f562fe0bfe954e8968f1d8683424fc331"
  end

  resource "tree-sitter-rust" do
    url "https://github.com/tree-sitter/tree-sitter-rust/archive/refs/tags/v0.24.2.tar.gz"
    sha256 "061e90a539a55a6aa65dceb0ad6425c50ab1a6e3e6d4ba430e2795ed4550f10e"
  end

  resource "tree-sitter-sql" do
    url "https://files.pythonhosted.org/packages/e8/5c/3d10387f779f36835486167253682f61d5f4fd8336b7001da1ac7d78f31c/tree_sitter_sql-0.3.11.tar.gz"
    sha256 "700b93be2174c3c83d174ec3e10b682f72a4fb451f0076c7ce5012f1d5a76cbc"
  end

  resource "tree-sitter-toml" do
    url "https://github.com/tree-sitter-grammars/tree-sitter-toml/archive/refs/tags/v0.7.0.tar.gz"
    sha256 "7d52a7d4884f307aabc872867c69084d94456d8afcdc63b0a73031a8b29036dc"
  end

  resource "tree-sitter-xml" do
    url "https://github.com/tree-sitter-grammars/tree-sitter-xml/archive/refs/tags/v0.7.0.tar.gz"
    sha256 "4330a6b3685c2f66d108e1df0448eb40c468518c3a66f2c1607a924c262a3eb9"
  end

  resource "tree-sitter-yaml" do
    url "https://files.pythonhosted.org/packages/57/b6/941d356ac70c90b9d2927375259e3a4204f38f7499ec6e7e8a95b9664689/tree_sitter_yaml-0.7.2.tar.gz"
    sha256 "756db4c09c9d9e97c81699e8f941cb8ce4e51104927f6090eefe638ee567d32c"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/ea/01/e5ac23733628a6bbb91913a765fcf55ee8070d8d991bc88fdaaf805052c7/wcwidth-0.9.4.tar.gz"
    sha256 "fd8d57d3cdfe570e3265c8fab1885c24e34ef40889c0759c0c304a19e9835954"
  end

  # FIXME: update-python-resources cannot handle psycopg-c which needs pg_config on PATH.
  # As a workaround, we track latest version of resource and fail the build if incorrect.
  resource "psycopg-c" do
    url "https://files.pythonhosted.org/packages/58/53/bf15aa48cd6f0ad0039b9f48681d2e76e8564d413af47b13fab50dd03555/psycopg_c-3.3.6.tar.gz"
    sha256 "29c568426ad61c1b702c7d73505c43ca2c9fc5d97a8431d8d9049e731e319ff8"

    livecheck do
      url :url
    end
  end

  allow_network_access! :build

  def install
    if resource("psycopg").version != resource("psycopg-c").version
      odie "Manually modify psycopg-c version to match psycopg==#{resource("psycopg").version}"
    end

    virtualenv_install_with_resources
    generate_completions_from_executable(bin/"harlequin", shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}/harlequin --profile none 2>&1", 2)
    assert_match "Harlequin couldn't load your profile", output

    assert_match version.to_s, shell_output("#{bin}/harlequin --version")
  end
end
