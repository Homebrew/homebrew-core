class Harlequin < Formula
  include Language::Python::Virtualenv

  desc "Easy, fast, and beautiful database client for the terminal"
  homepage "https://harlequin.sh", browsed: "2026-09-05"
  url "https://files.pythonhosted.org/packages/ef/9a/cff4402e0cf9d6cff4d8d7676806e54a63fd2481cffdf965f845281ffb94/harlequin-2.13.0.tar.gz"
  sha256 "b613ec50c170d2284200eb3e8a86a24b287d1fd99e4f1707077e0110732fc7f0"
  license "MIT"
  head "https://github.com/tconbeer/harlequin.git", branch: "main"

  no_autobump! because: "has non-PyPI resources"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d51a9389005242b73ea90578f92df8886cfa0a27fb0025c453fd2e145c1befee"
    sha256 cellar: :any, arm64_sequoia: "30a332ea95b4dd4978d68c7e03bbf43b768bb3d346576861b1abf3c1e3304fdd"
    sha256 cellar: :any, arm64_sonoma:  "0f5a40b4f6ed60c075c7da76474417d530b6a6ef4c0bfa099b9ac58334755b48"
    sha256 cellar: :any, arm64_linux:   "9848e223bbcb1d6f66227c2cbd56008af59bacbe3dc62bce735d5941d6ef863b"
    sha256 cellar: :any, x86_64_linux:  "9e76c6806421f02143f5e439e8fd9b122e7aa5ffa3667f8cb4f041875e583831"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build # pyarrow > libcst
  depends_on "apache-arrow"
  depends_on "libpq" # psycopg
  depends_on "libyaml" # pyarrow > pyyaml
  depends_on "numpy"
  depends_on "python@3.14"
  depends_on "unixodbc" # harlequin-odbc

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  pypi_packages package_name:     "harlequin[mysql,odbc,postgres]",
                exclude_packages: %w[numpy psycopg-binary tree-sitter-languages],
                extra_packages:   "psycopg-c"

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "duckdb" do
    url "https://files.pythonhosted.org/packages/7d/19/e57151753576373c6696a12022648546cca6038e8833fda2908ee2342d9b/duckdb-1.5.5.tar.gz"
    sha256 "72f33ee57ca7595b23957671a2cc7f7fe2be0ecc2d68f63abedcfcaa3a5c1238"
  end

  resource "harlequin-mysql" do
    url "https://files.pythonhosted.org/packages/28/86/e9fe658afd953b8580ad8399fad17f248b2dfab612fff5c2e2292d415f14/harlequin_mysql-1.4.0.tar.gz"
    sha256 "60eb100978711c4f8a6e1b702d7fed313f298b2b0641eed259a5415673f75d25"
  end

  resource "harlequin-odbc" do
    url "https://files.pythonhosted.org/packages/c1/1b/e5bc547d98771ce87a8c5ef3c96908e93c95406b50462085a3ebfcd2f86d/harlequin_odbc-0.4.0.tar.gz"
    sha256 "98356c5ebaacc23daff35e165d4490e1ea10dc591fa9cb0824f41272b39d13f0"
  end

  resource "harlequin-postgres" do
    url "https://files.pythonhosted.org/packages/fc/9a/43b082e83eed259438af8a32271584464b8a5a71ff0e5fc88a592fdb4525/harlequin_postgres-1.4.1.tar.gz"
    sha256 "e352c74312752f279aa33bf97284e322ef1447f18595b0b583265ad843df7bab"
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
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
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
    url "https://files.pythonhosted.org/packages/e3/60/f79b9b013a16fa3a58350c9295ddc6789f2e335f36ea61ed10a21b215364/msgspec-0.21.1.tar.gz"
    sha256 "2313508e394b0d208f8f56892ca9b2799e2561329de9763b19619595a6c0f72c"
  end

  resource "mysql-connector-python" do
    url "https://files.pythonhosted.org/packages/26/c9/a9446dbebbcdf7d828d0a3be9049607eab6eeffb4e46ef1ee8ac304baede/mysql_connector_python-9.7.0.tar.gz"
    sha256 "933887e71c871b6e9d8908459fe8303ebcf8feb5cc1e1c49caa6490e525cf78e"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/69/b7/802a56eca9f2fac455b8bab5375a2647b0f0e14a2cd63ef077de3c4a7658/platformdirs-4.11.7.tar.gz"
    sha256 "4f41487eeeeeb07f3a6625e61d9bc0ae6809f92d3386dbd74392fbb76108104d"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/72/73/8fb739d0f6bba247b9b93c9840c402a4f88545be5f1d4b02b23366371c00/psycopg-3.3.5.tar.gz"
    sha256 "d0a3d9ccf5788af054cbd745278cb02401b5c312aeaafbf2c6144460aec47da4"
  end

  resource "psycopg-c" do
    url "https://files.pythonhosted.org/packages/21/7b/5da2274bdbfed6b02aea463e2b803b8d4406bbc9d6c6f6bfd7122492254f/psycopg_c-3.3.5.tar.gz"
    sha256 "5e11edaa0040a64d0af351a8fd3e276a824cd92fe34abc350cd67aa07ad36c55"
  end

  resource "psycopg-pool" do
    url "https://files.pythonhosted.org/packages/90/82/7a23d26039827ecd4ebe93905651029ddd307c5182ad59296dfb6f67b528/psycopg_pool-3.3.1.tar.gz"
    sha256 "b10b10b7a175d5cc1592147dc5b7eec8a9e0834eb3ed2c4a92c858e2f51eb63c"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/3d/e3/27f57f80141379d60defe6703eb50a707325706f07fedfd1312c7a751995/pyarrow-25.0.1.tar.gz"
    sha256 "9150a83248bfed9813ea3c3af74c3856c1984d444aa28e58bf7733b9750ddf6a"
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
    url "https://files.pythonhosted.org/packages/f7/ea/21e4867ea0ef881ffd4c0550fc21a061435e50d6324bcd034396633cbc18/rich_click-1.9.8.tar.gz"
    sha256 "4008f921da88b5d91646c134ec881c1500e5a6b3f093e90e8f29400e09608371"
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
    url "https://files.pythonhosted.org/packages/1e/7b/79a2c566bf0a7e087c2b29738fdec807d2457b3553bf44b8fa034bfa1f1e/textual_fastdatatable-0.19.1.tar.gz"
    sha256 "c546de625c193b21431140c3e312c12d8cfdbefb61a5c9550b3dde7715c1d7a9"
  end

  resource "textual-textarea" do
    url "https://files.pythonhosted.org/packages/a2/e8/061ba3d6861984e5377b08bbf6f55d06fe43623d5bb4b26e27239a0f3959/textual_textarea-0.18.2.tar.gz"
    sha256 "55890c62e270dd6f4a8988e0cfc54120a05022eead82c665095dd2be14bf17a9"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/21/3b/6c24bec5be5e743ffd99576daa5cc077722fc7d5bbc00bd133fa0c698dc6/tqdm-4.70.0.tar.gz"
    sha256 "55b0b0dbd97462d06ebee91e4dac24ed4d4702be82b24f07e6c1d27e08cea220"
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
    url "https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/refs/tags/v0.5.1.tar.gz"
    sha256 "acaffe5a54b4890f1a082ad6b309b600b792e93fc6ee2903d022257d5b15e216"
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
    url "https://files.pythonhosted.org/packages/36/57/ed58088fafdf4c55a0ad6bde846502567645424d7ebf325230b9237f4085/wcwidth-0.8.3.tar.gz"
    sha256 "d128512515fbf4612e0ff21fd6380399210318b7b54a9af59dff8454cf9730eb"
  end

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin/"harlequin", shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}/harlequin --profile none 2>&1", 2)
    assert_match "Harlequin couldn't load your profile", output

    assert_match version.to_s, shell_output("#{bin}/harlequin --version")
  end
end
