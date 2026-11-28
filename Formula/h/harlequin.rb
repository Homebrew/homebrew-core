class Harlequin < Formula
  include Language::Python::Virtualenv

  desc "Easy, fast, and beautiful database client for the terminal"
  homepage "https://harlequin.sh", browsed: "2026-09-05"
  url "https://files.pythonhosted.org/packages/06/ab/8042af82e03ee1152792ac04e81124da66659283166c04dc712854987274/harlequin-2.18.0.tar.gz"
  sha256 "8b2797c945dbd5d96279eb9ac5028464d4d0b870f5d7beea7309309ccee802fd"
  license "MIT"
  head "https://github.com/tconbeer/harlequin.git", branch: "main"

  bottle do
    manifest_sha256 "b1da60e5b992e01583377615aa53c79a68c879f2e4381d2b2f0e9d1a6c29d2c1"
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
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "duckdb" do
    url "https://files.pythonhosted.org/packages/49/d8/ebb8ff07c617d1a8c25e7f7718a6955d2d5f7e539ec5219be1da478c0a42/duckdb-2.0.1.tar.gz"
    sha256 "5b3f493140e35b75298ee0fc606d98e3065e8601e64fe81b09326de7a6fd68e0"
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
    url "https://files.pythonhosted.org/packages/16/fc/cee2c45553c9a9bf77d8b0c391560c556d7ed756b1f0bb35eb5d48db09ea/markdown_it_py-4.3.0.tar.gz"
    sha256 "91a58fa5b72c71a40cf7177250fd767480d7a2bb3ac426ccfb76fb90305fdaaa"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/ad/a4/77a4e1be19fd9b08993c76d5e54979ac836b327754f1f5fecfed1b56cc67/mdit_py_plugins-0.7.0.tar.gz"
    sha256 "26d2179227aaf4d1dc7acffe7a738cbd15cade6b5a61cff0a2cbf9fed93efede"
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
    url "https://files.pythonhosted.org/packages/71/18/0b0d99f5bf164f04a7a9534c3dbdbe4d5fd2b382667685ad40c192c4d3d1/platformdirs-4.14.8.tar.gz"
    sha256 "96893d686e84e9e6f358a9ea41a8de544df66dbf2ba6cda250e7dc73acf85b9b"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/b4/74/ff710399dfa9fe9b546c2f5a05ea2f9b9d1dc2145c0b59e53a3fa2013679/psycopg-3.3.9.tar.gz"
    sha256 "87c1d85c3e0e88e811d3c0b3808f947bd967c6faf34af6cd86fd021f77793d6c"
  end

  resource "psycopg-pool" do
    url "https://files.pythonhosted.org/packages/74/5e/c0664b968b102ff68b811d999c728546c48d5c1eec03e3bbaf88c0cb4472/psycopg_pool-3.3.3.tar.gz"
    sha256 "df87b5d9d0ad7db37f6cdad4fa8ce113d250f5997f6db38e9a99192fb67f9e1d"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/bc/5e/9cb2a56d5e293aab4e2fbecc5b0620d93227d66b8d5a63c554c31e1f80fe/pyarrow-26.0.1.tar.gz"
    sha256 "93affcbd8a343e98dc19e9ec8fe17271ebf8fe98102d8b7454175074409f8b72"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyodbc" do
    url "https://files.pythonhosted.org/packages/fb/59/f5ccca0627e6a17de95ed7689276efa172864314ead446f1d0290bf8ef03/pyodbc-5.5.0.tar.gz"
    sha256 "7a78873cac66b2857bf490a24a3e3aada24f839534e97c67e177f691e7d701ac"
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
    url "https://files.pythonhosted.org/packages/19/38/440fb4f9a6007291301a6f8facdb79e0a430d2df3ef2fbd07d5b54783b44/textual_fastdatatable-0.19.5.tar.gz"
    sha256 "5e6140e13f6a18d6ea827d1e97e9cb8be12253fad4ad58e14afd6dab966c35bc"
  end

  resource "textual-textarea" do
    url "https://files.pythonhosted.org/packages/f6/35/abb09e482584e1ee69de2fc9caf9936e448d1386367bcc4540b7279fe4f1/textual_textarea-0.18.5.tar.gz"
    sha256 "21b5c700aee4cdd15c639e09edd737a62da026a138931c1f921c0805a6438967"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/c9/85/4a7c68111c057a6498f5bc721ef93b388b420bb31d7020759f18a5f0c2ec/tomlkit-0.15.3.tar.gz"
    sha256 "b3c3020ec1a4bd469d12e31fb4da938e7f6ba758cdbec3fd9047db63120eaf81"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/e6/ca/3d69b21b2328dadee34a6cae65bc84e2b4e0c72bfb9147b7a2d4ba8110a0/tree_sitter-0.26.1.tar.gz"
    sha256 "9919cbaf02d17fa9a4cd0e6da496aecf901b758e6eacf122eee393e3ef08aacd"
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
    url "https://files.pythonhosted.org/packages/48/eb/6471aecccf74ef4db33628c9f93d87f8975ecf1c768ff7ae5753956813c7/tree_sitter_sql-0.3.13.tar.gz"
    sha256 "51d7839f7d29f6bc3814d128dc54dc890908450bce99f48ba2d20dbe33dbe061"
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
    url "https://files.pythonhosted.org/packages/8e/da/d59374b2c893ae70a41fdb064637ccef218f25df8c67e5431a96708235d9/wcwidth-0.9.5.tar.gz"
    sha256 "713534e2ecb16e0fc39f19e0a5dda997da76d010953e9e8f803e7971f8accd80"
  end

  # FIXME: update-python-resources cannot handle psycopg-c which needs pg_config on PATH.
  # As a workaround, we track latest version of resource and fail the build if incorrect.
  resource "psycopg-c" do
    url "https://files.pythonhosted.org/packages/bc/2b/09dece13af82681cad81a70d21da76ecf37bc280a15693a3fe966751649f/psycopg_c-3.3.9.tar.gz"
    sha256 "591fcbcb40e089235a7f096b9e887e71ccae78fd337aba198d918e33707c5e01"

    livecheck do
      url :url
    end
  end

  allow_network_access! :build

  def install
    if resource("psycopg").version != resource("psycopg-c").version
      psycopg_version = resource("psycopg").version
      odie "Manually modify psycopg-c version to match psycopg==#{psycopg_version}"
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
