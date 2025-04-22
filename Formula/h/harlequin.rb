class Harlequin < Formula
  include Language::Python::Virtualenv

  desc "Easy, fast, and beautiful database client for the terminal"
  homepage "https://harlequin.sh"
  url "https://files.pythonhosted.org/packages/b2/e2/e9176c2102b0f9fa4384dcf6e20aa11aedd50f446180cca32e44e06f7fe1/harlequin-2.1.2.tar.gz"
  sha256 "751f71384a40443810f192f48f1c9bbd6f24be053231368971c2271fb56956fa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1cb7396dda2a840f7ffa488d3d7f6358152c727df60e22437de383732a7683c1"
    sha256 cellar: :any,                 arm64_sonoma:  "0728497b8ddbc348a4ca7c4cc41f981e4ce826c18e0ee357ae431ddea080bd91"
    sha256 cellar: :any,                 arm64_ventura: "89cb5cc85f0d2c0f982398bc4905a70035b8e8cfb771219c91b1d209147700b8"
    sha256 cellar: :any,                 sonoma:        "e5fb063890fae202945e5eb1e3314d3963163572156437c04415fd5ed3d831ca"
    sha256 cellar: :any,                 ventura:       "02f939918ee3d829e710cd5bbbfe838222d688fe753c5f5e62c31d66bdbdcda1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf2bd77c91b8a9bb130174383d7e5c72635d9a9d24e6e4eba63c94073b21909b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbd4614f5777dcc7a2ba3e83b48fca042e2f0c9713673f0e5312f24fa5638c63"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "apache-arrow"
  depends_on "libpq" # psycopg
  depends_on "numpy"
  depends_on "python@3.13"
  depends_on "unixodbc" # harlequin-odbc

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/5a/25/886e197c97a4b8e254173002cdc141441e878ff29aaa7d9ba560cd6e4866/cython-3.0.12.tar.gz"
    sha256 "b988bb297ce76c671e28c97d017b95411010f7c77fa6623dd0bb47eed1aee1bc"
  end

  resource "duckdb" do
    url "https://files.pythonhosted.org/packages/28/b8/0f86278684fb7a1fac7c0c869fc6d68ed005cdc91c963eb4373e0551bc0a/duckdb-1.2.2.tar.gz"
    sha256 "1e53555dece49201df08645dbfa4510c86440339889667702f936b7d28d39e43"
  end

  resource "harlequin-mysql" do
    url "https://files.pythonhosted.org/packages/44/e1/d210f15f8090a7c0834b3bf90c46d202028d401fe96e9dd86e59abfaad40/harlequin_mysql-1.1.0.tar.gz"
    sha256 "7a5a82e5c2eb9383a30443d387a139a4509b111afc2fe935b619e6c73409ee7b"
  end

  resource "harlequin-odbc" do
    url "https://files.pythonhosted.org/packages/e5/c0/a012185883fd7d472954e945dbcb5fbad50272c5d0b84396886896bf8682/harlequin_odbc-0.3.1.tar.gz"
    sha256 "c12ea98101ba5dffe212df2d5fbe0aef2e786eaa58d03d911bc3bbf89491be01"
  end

  resource "harlequin-postgres" do
    url "https://files.pythonhosted.org/packages/af/d3/ec374f95a2a4a2eecf4cbd256d018bd1fbd45df97466f5fba253d91fa352/harlequin_postgres-1.2.0.tar.gz"
    sha256 "f544b469a5cfd85f9454cf69638dcaa67074e4a0b4fee0f1ae964060e27e451d"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2a/ae/bb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96a/linkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/19/03/a2ecab526543b152300717cf232bb4bb8605b6edb946c845016fa9c9c9fd/mdit_py_plugins-0.4.2.tar.gz"
    sha256 "5f2cd1fdb606ddf152d37ec30e46101a60512bc0e5fa1a7002c36647b09e26b5"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  # upstream bug report on pypi artifact issue, https://bugs.mysql.com/bug.php?id=113396
  resource "mysql-connector-python" do
    url "https://github.com/mysql/mysql-connector-python/archive/refs/tags/8.4.0.tar.gz"
    sha256 "52944d6fa84c903fd70723a47d2f8c3153c50ae91773f1584a7bd30606c58b35"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b6/2d/7d512a3913d60623e7eb945c6d1b4f0bddf1d0b7ada5225274c87e5b53d1/platformdirs-4.3.7.tar.gz"
    sha256 "eb437d586b6a0986388f0d6f74aa0cde27b48d0e3d66843640bfb6bdcdb6e351"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/bb/6e/9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1c/prompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/67/97/eea08f74f1c6dd2a02ee81b4ebfe5b558beb468ebbd11031adbf58d31be0/psycopg-3.2.6.tar.gz"
    sha256 "16fa094efa2698f260f2af74f3710f781e4a6f226efe9d1fd0c37f384639ed8a"
  end

  resource "psycopg-c" do
    url "https://files.pythonhosted.org/packages/2f/f1/367a2429af2b97f6a46dc116206cd3b1cf668fca7ff3c22b979ea0686427/psycopg_c-3.2.6.tar.gz"
    sha256 "b5fd4ce70f82766a122ca5076a36c4d5818eaa9df9bf76870bc83a064ffaed3a"
  end

  resource "psycopg-pool" do
    url "https://files.pythonhosted.org/packages/cf/13/1e7850bb2c69a63267c3dbf37387d3f71a00fd0e2fa55c5db14d64ba1af4/psycopg_pool-3.2.6.tar.gz"
    sha256 "0f92a7817719517212fbfe2fd58b8c35c1850cdd2a80d36b581ba2085d9148e5"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/7f/09/a9046344212690f0632b9c709f9bf18506522feb333c894d0de81d62341a/pyarrow-19.0.1.tar.gz"
    sha256 "3bf266b485df66a400f282ac0b6d1b500b9d2ae73314a153dbe97d6d5cc8a99e"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyodbc" do
    url "https://files.pythonhosted.org/packages/a0/36/a1ac7d23a1611e7ccd4d27df096f3794e8d1e7faa040260d9d41b6fc3185/pyodbc-5.2.0.tar.gz"
    sha256 "de8be39809c8ddeeee26a4b876a6463529cd487a60d1393eb2a93e9bcd44a8f5"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/30/23/2f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60d/pyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/a8/b8/d16eb579277f3de9e56e5ad25280fab52fc5774117fb70362e8c2e016559/questionary-2.1.0.tar.gz"
    sha256 "6302cdd645b19667d8f6e6634774e9538bfcd1aad9be287e743d96cacaf95587"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a1/53/830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8/rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "rich-click" do
    url "https://files.pythonhosted.org/packages/a6/7a/4b78c5997f2a799a8c5c07f3b2145bbcda40115c4d35c76fbadd418a3c89/rich_click-1.8.8.tar.gz"
    sha256 "547c618dea916620af05d4a6456da797fbde904c97901f44d2f32f89d85d6c84"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/a9/5a/0db4da3bc908df06e5efae42b44e75c81dd52716e10192ff36d0c1c8e379/setuptools-78.1.0.tar.gz"
    sha256 "18fd474d4a82a5f83dac888df697af65afa82dec7323d09c3e37d1f14288da54"
  end

  resource "shandy-sqlfmt" do
    url "https://files.pythonhosted.org/packages/e9/82/43763176f899a87ea66cfe335659862ca2c623de7382d164f01ea35519fd/shandy_sqlfmt-0.26.0.tar.gz"
    sha256 "d95abd381640a846c71b0e2effb30d47f0b3eb5f69fb337fafe663634857f7a5"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/4b/cb/b3ff0e45d812997a527cb581a4cd602f0b28793450aa26201969fd6ce42c/textual-0.89.1.tar.gz"
    sha256 "66befe80e2bca5a8c876cd8ceeaf01752267b6b1dc1d0f73071f1f1e15d90cc8"
  end

  resource "textual-fastdatatable" do
    url "https://files.pythonhosted.org/packages/ef/da/9e86cadf3824df250126616a19d3b79f48f13e0f336605e1a2ab3d5a0aef/textual_fastdatatable-0.12.0.tar.gz"
    sha256 "56b035e22d694fa902a8b80120765addd6e32f4eee0151ee46fa6ab1deaad59e"
  end

  resource "textual-textarea" do
    url "https://files.pythonhosted.org/packages/da/85/e3dd273455337efe8e9f14bd8b048e7f22a40ad86615a69866a03967715c/textual_textarea-0.15.0.tar.gz"
    sha256 "1343604a4dc3bac0337c58d926a02ddcf451956fb12532a3d5ade9219905f426"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/b1/09/a439bec5888f00a54b8b9f05fa94d7f901d6735ef4e55dcec9bc37b5d8fa/tomlkit-0.13.2.tar.gz"
    sha256 "fff5fe59a87295b278abd31bec92c15d9bc4a06885ab12bcea52c71119392e79"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/4a/64/71b3a0ff7d0d89cb333caeca01992099c165bdd663e7990ea723615e60f4/tree_sitter-0.20.4.tar.gz"
    sha256 "6adb123e2f3e56399bbf2359924633c882cc40ee8344885200bca0922f713be5"
  end

  # sdist issue report, https://github.com/grantjenks/py-tree-sitter-languages/issues/63
  # https://github.com/grantjenks/py-tree-sitter-languages/issues/54
  resource "tree-sitter-languages" do
    url "https://github.com/grantjenks/py-tree-sitter-languages/archive/refs/tags/v1.10.2.tar.gz"
    sha256 "cdd03196ebaf8f486db004acd07a5b39679562894b47af6b20d28e4aed1a6ab5"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/37/23083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061/typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/91/7a/146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8/uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    venv = virtualenv_install_with_resources without: "mysql-connector-python"

    # PyPI sdist is broken (missing at least setup.py)
    # https://bugs.mysql.com/bug.php?id=113396
    resource("mysql-connector-python").stage do
      venv.pip_install Pathname.pwd/"mysql-connector-python"
    end

    generate_completions_from_executable(bin/"harlequin", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}/harlequin --profile none", 2)
    assert_match "Harlequin couldn't load your profile", output

    assert_match version.to_s, shell_output("#{bin}/harlequin --version")
  end
end
