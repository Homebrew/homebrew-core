class Btcli < Formula
  include Language::Python::Virtualenv

  desc "Bittensor command-line tool"
  homepage "https://docs.learnbittensor.org/btcli"
  url "https://files.pythonhosted.org/packages/58/5f/fd9ede99e419ec618d5b6e6136b62a94840bd45be3af8bb0ded5f45cfbb4/bittensor_cli-9.23.2.tar.gz"
  sha256 "0770e70cd756328093f32556561faa548a8ea357ddc5726918b9422068d2a25d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cd66ced85caa927fc232ba3a42fd3207823b194a89d7cc467941b41e8c242040"
    sha256 cellar: :any, arm64_sequoia: "27f15b2b825b3b2fa9439421752904b283d6ce1bb7c77bf300a5f3706a3740e9"
    sha256 cellar: :any, arm64_sonoma:  "e36967d257272c1354b845eaf51254cc924a679c960101086ecf4a10cb1d9de9"
    sha256 cellar: :any, sonoma:        "610ad3d89f8c20fcd311ac6a602d34ab3001f4061d8b82d148d965dbbde01b35"
    sha256 cellar: :any, arm64_linux:   "2103af4d0efd7fef4a1eabf429a2018a683d840eaa0db906516ef5dda07769e6"
    sha256 cellar: :any, x86_64_linux:  "ce5a5e1273092385254bbdd077740282045952647236287c01676028af77d6e8"
  end

  deprecate! date: "2026-07-19", because: :repo_removed, replacement_formula: "bittensor"
  disable! date: "2027-01-19", because: :repo_removed, replacement_formula: "bittensor"

  depends_on "rust" => :build # for bittensor-wallet, plotly

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "openssl@3"
  depends_on "python@3.14"
  depends_on "xxhash"

  conflicts_with "bittensor", "btpd", because: "both install `btcli` binaries"

  pypi_packages exclude_packages: %w[certifi numpy]

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/82/78/8ea7308cac6934de8c74a14f3d5f65d1c89287426688be79538d0e5c013d/aiohttp-3.14.1.tar.gz"
    sha256 "307f2cff90a764d329e77040603fa032db89c5c24fdad50c4c15334cba744035"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/4e/8a/64761f4005f17809769d23e518d915db74e6310474e733e3593cfc854ef1/aiosqlite-0.22.1.tar.gz"
    sha256 "043e0bd78d32888c0a9ca90fc788b38796843360c855a7262a532813133a0650"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "async-substrate-interface" do
    url "https://files.pythonhosted.org/packages/69/9b/29b1d609ed59bb768f913853e664dbac9d6490207a0ada154cbd5a1c7883/async_substrate_interface-2.2.1.tar.gz"
    sha256 "bd5ca091dfbbbb27d0bba6fc0e24aea3ca5a00c7439e23d0bacd0c8270c85ffd"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "bittensor-drand" do
    url "https://files.pythonhosted.org/packages/70/c8/f1fdee0f0f5088585d6804a0099554f66834fd6d7347b921a0fedfc18e73/bittensor_drand-2.0.0.tar.gz"
    sha256 "517cd8cabb4634a980e26aaf85ac0a8481f62fefadc0499ddbadb6467ae030c7"
  end

  resource "bittensor-wallet" do
    url "https://files.pythonhosted.org/packages/a0/30/7eb06cfd5d901d2cd3760a8b85d66c7b84f96f03d6d0402b306fdf8b6a2d/bittensor_wallet-4.1.0.tar.gz"
    sha256 "f0f34641a4b9110def9e35fe22498195fcb31d143dc4f76dd9022db374ccd484"
  end

  resource "cyscale" do
    url "https://files.pythonhosted.org/packages/8e/02/b77c019e7d697ede8bd7bcd9472569a45e3ff7df6aaa8eb90abde5ac190f/cyscale-0.5.0.tar.gz"
    sha256 "57bf8fb401c71d5d8c7dbadd948c1fbb239b014ad58eb2f43722beb39ebc50e9"
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
    url "https://files.pythonhosted.org/packages/59/30/a8a0c15f9480dc91b5b7f11ebd26105e5f80898d7ff02da197fef35d8395/gitpython-3.1.51.tar.gz"
    sha256 "22c9c94bb6b0b9f3c7157c684fece45a414cea204586b600beae6cd4570dcd6d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "narwhals" do
    url "https://files.pythonhosted.org/packages/e8/ac/66ed1fc6e38a0c0f330627ec5c5d597990d6159b6712b82af0ad2c65f06c/narwhals-2.23.0.tar.gz"
    sha256 "13e7ff5b4bb4a2f77b907c2e4d8a76e273dfc1323a3c997440a2f9fd26aed408"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/54/90/188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229d/netaddr-1.3.0.tar.gz"
    sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "plotille" do
    url "https://files.pythonhosted.org/packages/46/51/a6093145179139e7dffc01aa499b0169c91154a743197a3fd16252a9e90d/plotille-6.0.5.tar.gz"
    sha256 "26d2cef5d4feb8632c9710442ad49fc57f9d5b20881c21ac7954c76208b5600b"
  end

  resource "plotly" do
    url "https://files.pythonhosted.org/packages/96/07/795c79dbce40c39bece88e69d049babbd23ffa95b5d117f248db8ea03abb/plotly-6.9.0.tar.gz"
    sha256 "967ad33e8c704fed051800d11d985eb206a9c795c14206b30a6f463ed9c67d0d"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/ec/44/c87281c333769159c50594f22610f77398a47ccbfbbf23074e744e86f87c/propcache-0.5.2.tar.gz"
    sha256 "01c4fc7480cd0598bb4b57022df55b9ca296da7fc5a8760bd8451a7e63a7d427"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/7c/f7/68adc395201b20b872d68e975386832e8005ffeacedd43a1d837a32815be/typer-0.26.8.tar.gz"
    sha256 "c244a6bd558886fe3f8780efb6bdd28bb9aff005a94eedebaa5cb32926fe2f7e"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/8c/02/b9a097e1e16fee4e2fd1ec8c39f6a9c5d6257bae8fa12640caf869f54436/websockets-16.1.tar.gz"
    sha256 "299468cbe42e2b9981134c7c51d99387d8a7bf562b00183b3eec53f882846dad"
  end

  resource "xxhash" do
    url "https://files.pythonhosted.org/packages/8e/63/71aa56b151a1b28770037a61bd4e461c2619cfc8866a4fcaf1548605e325/xxhash-3.8.1.tar.gz"
    sha256 "b0de4bf3aa66363552d52c6a89003c479911f12098cd48a53d44a0f7a25f7c46"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/79/12/1e8f37460ea0f7eb59c221fdaf0ed75e7ac43e97f8093b9c6f411df50a78/yarl-1.24.2.tar.gz"
    sha256 "9ac374123c6fd7abf64d1fec93962b0bd4ee2c19751755a762a72dd96c0378f8"
  end

  def install
    ENV.O0
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    ENV["XXHASH_LINK_SO"] = "1"
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"btcli", shell_parameter_format: :typer)
  end

  test do
    require "json"
    wallet_path = testpath/"btcli-brew-test"
    test_wallet_name = "brew-test"
    ss58_address = "5FHneW46xGXgs5mUiveU4sbTyGBzmstUspZC92UhjJM694ty"

    # Create wallet
    create_args = %W[
      --wallet-name #{test_wallet_name}
      --wallet-path #{wallet_path}
      --hotkey default
      --no-use-password
      --uri Bob
      --overwrite
      --json-output
    ]
    output = shell_output("#{bin}/btcli w create #{create_args.join(" ")}")

    expected_create = {
      "success" => true,
      "error"   => "",
      "data"    =>
                   {
                     "name"         => test_wallet_name,
                     "path"         => wallet_path.to_s,
                     "hotkey"       => "default",
                     "hotkey_ss58"  => ss58_address,
                     "coldkey_ss58" => ss58_address,
                   },
    }

    parsed_create = JSON.parse(output)
    assert_equal expected_create, parsed_create

    # Check balance of the created wallet on the finney network
    balance_args = %W[
      --network finney
      --wallet-path #{wallet_path}
      --wallet-name #{test_wallet_name}
      --json-output
    ]
    balance_output = shell_output("#{bin}/btcli w balance #{balance_args.join(" ")}")

    expected_balance = {
      "balances" => {
        "brew-test" => {
          "coldkey" => ss58_address,
          "free"    => 0.0,
          "staked"  => 0.0,
          "total"   => 0.0,
        },
      },
      "totals"   => {
        "free"   => 0.0,
        "staked" => 0.0,
        "total"  => 0.0,
      },
    }

    parsed_balance = JSON.parse(balance_output)
    assert_equal expected_balance, parsed_balance
  end
end
