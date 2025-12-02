class Harlequin < Formula
  include Language::Python::Virtualenv

  desc "Easy, fast, and beautiful database client for the terminal"
  homepage "https://harlequin.sh"
  url "https://files.pythonhosted.org/packages/84/81/0b2d50e4f0bef2d7ccda8e0364c1b2864a6cd0d6da4ea8366911f61ee68d/harlequin-2.4.1.tar.gz"
  sha256 "05a9f041021a8d7fa7bdb97cac8c26ca0233235fa553d9d7c53e238097297655"
  license "MIT"
  revision 1
  head "https://github.com/tconbeer/harlequin.git", branch: "main"

  no_autobump! because: "has non-PyPI resources"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "44a60cd93a8b33477e038d2a7165cbc3bfcb18f7a2748473540e8bd0fdd9f915"
    sha256 cellar: :any, arm64_sequoia: "4cd4b782c29e75324a8c91af608200ec193bd3f7c296acd2ba05e6d964a9aa22"
    sha256 cellar: :any, arm64_sonoma:  "8b1f5cadc7bda9105d5a593ec8307c1bc67432b67e9ca97c2992e5855b8e47d9"
    sha256 cellar: :any, sonoma:        "1e6c2c590b443545aee81265fcc3ed7332bf43df0d15d9fe7a18eb870b474747"
    sha256               arm64_linux:   "c16b05f3aef2e747e1099fffbab1f2a7af83fb49a0315babe7dc658609803fbe"
    sha256               x86_64_linux:  "609168fe523a53d37a818514e98ef91d6872246c458667de39657beeeba86865"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "apache-arrow"
  depends_on "libpq" # psycopg
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
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "duckdb" do
    url "https://files.pythonhosted.org/packages/fc/23/690341f9d07eae3a33d07cce4f6730856c085331d5819ed09e68409ec6cf/duckdb-1.5.0.dev94.tar.gz"
    sha256 "14f44ec532d2d151f65e4e55306f429f7b9fc3c38f1c1788bb87bf8d003bfbb8"
  end

  resource "harlequin-mysql" do
    url "https://files.pythonhosted.org/packages/5a/66/15e9df6a4c99bbb887869e5b01d02ee5a8d5811239573c975a267fbd2fd3/harlequin_mysql-1.3.0.tar.gz"
    sha256 "98840b0e03be1c16ea62c5bbae2e8b87cd16b25a7913c7239aee3a1c06143131"
  end

  resource "harlequin-odbc" do
    url "https://files.pythonhosted.org/packages/c1/1b/e5bc547d98771ce87a8c5ef3c96908e93c95406b50462085a3ebfcd2f86d/harlequin_odbc-0.4.0.tar.gz"
    sha256 "98356c5ebaacc23daff35e165d4490e1ea10dc591fa9cb0824f41272b39d13f0"
  end

  resource "harlequin-postgres" do
    url "https://files.pythonhosted.org/packages/53/f2/1583d9c25b6245a04ab982fcf6bc08e6602668ecd8c5003f398dce267dad/harlequin_postgres-1.3.0.tar.gz"
    sha256 "d3532594693c745796b5ba4434218662ce3f9e5abb68b2e4159a825c62eb378b"
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
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/b2/fd/a756d36c0bfba5f6e39a1cdbdbfdd448dc02692467d83816dff4592a1ebc/mdit_py_plugins-0.5.0.tar.gz"
    sha256 "f4918cb50119f50446560513a8e311d574ff6aaed72606ddae6d35716fe809c6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mysql-connector-python" do
    url "https://files.pythonhosted.org/packages/39/33/b332b001bc8c5ee09255a0d4b09a254da674450edd6a3e5228b245ca82a0/mysql_connector_python-9.5.0.tar.gz"
    sha256 "92fb924285a86d8c146ebd63d94f9eaefa548da7813bc46271508fdc6cc1d596"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/33/01/d40b85317f86cf08d853a4f495195c73815fdf205eef3993821720274518/pandas-2.3.3.tar.gz"
    sha256 "e05e1af93b977f7eafa636d043f9f94c7ee3ac81af99c13508215942e64c993b"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/fb/93/180be2342f89f16543ec4eb3f25083b5b84eba5378f68efff05409fb39a9/prompt_toolkit-3.0.36.tar.gz"
    sha256 "3e163f254bef5a03b146397d7c1963bd3e2812f0964bb9a24e6ec761fd28db63"
  end

  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/a8/77/c72d10262b872617e509a0c60445afcc4ce2cd5cd6bc1c97700246d69c85/psycopg-3.2.12.tar.gz"
    sha256 "85c08d6f6e2a897b16280e0ff6406bef29b1327c045db06d21f364d7cd5da90b"
  end

  resource "psycopg-c" do
    url "https://files.pythonhosted.org/packages/68/27/33699874745d7bb195e78fd0a97349908b64d3ec5fea7b8e5e52f56df04c/psycopg_c-3.2.12.tar.gz"
    sha256 "1c80042067d5df90d184c6fbd58661350b3620f99d87a01c882953c4d5dfa52b"
  end

  resource "psycopg-pool" do
    url "https://files.pythonhosted.org/packages/9d/8f/3ec52b17087c2ed5fa32b64fd4814dde964c9aa4bd49d0d30fc24725ca6d/psycopg_pool-3.2.7.tar.gz"
    sha256 "a77d531bfca238e49e5fb5832d65b98e69f2c62bfda3d2d4d833696bdc9ca54b"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/30/53/04a7fdc63e6056116c9ddc8b43bc28c12cdd181b85cbeadb79278475f3ae/pyarrow-22.0.0.tar.gz"
    sha256 "3d600dc583260d845c7d8a6db540339dd883081925da2bd1c5cb808f720b3cd9"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyodbc" do
    url "https://files.pythonhosted.org/packages/8f/85/44b10070a769a56bd910009bb185c0c0a82daff8d567cd1a116d7d730c7d/pyodbc-5.3.0.tar.gz"
    sha256 "2fe0e063d8fb66efd0ac6dc39236c4de1a45f17c33eaded0d553d21c199f4d05"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/84/d0/d73525aeba800df7030ac187d09c59dc40df1c878b4fab8669bdc805535d/questionary-2.0.1.tar.gz"
    sha256 "bcce898bf3dbb446ff62830c86c5c6fb9a22a54146f0f5597d3da43b10d8fc8b"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "rich-click" do
    url "https://files.pythonhosted.org/packages/9a/31/103501e85e885e3e202c087fa612cfe450693210372766552ce1ab5b57b9/rich_click-1.8.5.tar.gz"
    sha256 "a3eebe81da1c9da3c32f3810017c79bd687ff1b3fa35bfc9d8a3338797f1d1a1"
  end

  resource "shandy-sqlfmt" do
    url "https://files.pythonhosted.org/packages/83/96/9e4ecbe43d4bb91d651f5f091c5f72204461b1568dc5a5eaa246a64b562f/shandy_sqlfmt-0.28.2.tar.gz"
    sha256 "0a78a2eee23f8b84b19a2895ca4608237d6da19037ce71346417fe01e97bad8b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/23/6c/565521dc6dd00fa857845483ae0c070575fda1f9a56d92d732554fecfea4/textual-6.4.0.tar.gz"
    sha256 "f40df9165a001c10249698d532f2f5a71708b70f0e4ef3fce081a9dd93ffeaaa"
  end

  resource "textual-fastdatatable" do
    url "https://files.pythonhosted.org/packages/1e/ec/8cc2204560200dcc80abc432a61eb6f99672049aecfd0860472cfc3f82fe/textual_fastdatatable-0.14.0.tar.gz"
    sha256 "cb99e208fb96c7eb5cfb7f225a280da950bd8cfb29d685a49071787c80218901"
  end

  resource "textual-textarea" do
    url "https://files.pythonhosted.org/packages/d1/9e/1aa70bab939cac85442cbfe3ef94383329b6cbe2535223940f6846252582/textual_textarea-0.17.2.tar.gz"
    sha256 "84bb2bfe545db70071914802e808dc411c16c21e7744adbcfc381f1390dd2c6b"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/cc/18/0bbf3884e9eaa38819ebe46a7bd25dcd56b67434402b66a58c4b8e552575/tomlkit-0.13.3.tar.gz"
    sha256 "430cf247ee57df2b94ee3fbe588e71d362a941ebb545dec29b53961d61add2a1"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/66/7c/0350cfc47faadc0d3cf7d8237a4e34032b3014ddf4a12ded9933e1648b55/tree-sitter-0.25.2.tar.gz"
    sha256 "fe43c158555da46723b28b52e058ad444195afd1db3ca7720c59a254544e9c20"
  end

  resource "tree-sitter-bash" do
    url "https://files.pythonhosted.org/packages/bb/94/fe115f24fd8a3e1073e240c1e766b573ea678a87f1f5e036ec071bdfe419/tree_sitter_bash-0.25.0.tar.gz"
    sha256 "6b6410ea5f54abe8780e4b260b01adbfec3a0729907c7a62a3448f670010e72e"
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
    url "https://github.com/tree-sitter/tree-sitter-rust/archive/refs/tags/v0.24.0.tar.gz"
    sha256 "79c9eb05af4ebcce8c40760fc65405e0255e2d562702314b813a5dec1273b9a2"
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
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/91/7a/146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8/uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin/"harlequin", shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}/harlequin --profile none", 2)
    assert_match "Harlequin couldn't load your profile", output

    assert_match version.to_s, shell_output("#{bin}/harlequin --version")
  end
end
