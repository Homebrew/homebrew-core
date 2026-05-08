class Btcli < Formula
  include Language::Python::Virtualenv

  desc "Bittensor command-line tool"
  homepage "https://docs.bittensor.com/btcli"
  url "https://files.pythonhosted.org/packages/87/7b/68de741a574a0f28e06acf9dc87dd3443c8227d286981fa394699eecd90a/bittensor_cli-9.21.1.tar.gz"
  sha256 "bff86ca875f3e120227f25e432bf17243b49154d68d88891581d7337f7a2ae33"
  license "MIT"
  head "https://github.com/opentensor/btcli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "658fab8bb6ce13f6a29cd352206402c97086e4fcbf2d8d3f32001ca0df9d166e"
    sha256 cellar: :any,                 arm64_sequoia: "67c462ccb8ac7dbe38e27452b9ffb01ded97764ebf0f1ea4cad932220699d21e"
    sha256 cellar: :any,                 arm64_sonoma:  "7e88f8edec0e4e8ddd1495bd7b8fe4c42fddb5ce55e5f45875f713185538b481"
    sha256 cellar: :any,                 sonoma:        "e4585b4075a317a10df38bef0d7a421b7ac727991469e5ba80693b7aa049162b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "597a01bc1b8f8b6295769a41761d23e531612165548a64500ed5e1a1bf9f8647"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a0a61642e596be462215e8cfe83e9dedf31d6ad8878ab3016e528306e7bfddf"
  end

  depends_on "rust" => :build # for bittensor-wallet, plotly

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "openssl@3"
  depends_on "python@3.14"

  conflicts_with "btpd", because: "both install `btcli` binaries"

  pypi_packages exclude_packages: %w[certifi numpy]

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/77/9a/152096d4808df8e4268befa55fba462f440f14beab85e8ad9bf990516918/aiohttp-3.13.5.tar.gz"
    sha256 "9d98cc980ecc96be6eb4c1994ce35d28d8b1f5e5208a23b421187d1209dbb7d1"
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
    url "https://files.pythonhosted.org/packages/50/e6/387dc39e5a6731cfbc4e4ebbbffdcdbcf5ac22c61588cf0f112c64121eb0/async_substrate_interface-2.0.3.tar.gz"
    sha256 "35692730cea1f2aa6a9cbc526ecf67a07b3a67e88b2afc68d5db38058173dd7e"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "base58" do
    url "https://files.pythonhosted.org/packages/7f/45/8ae61209bb9015f516102fa559a2914178da1d5868428bd86a1b4421141d/base58-2.1.1.tar.gz"
    sha256 "c5d0cb3f5b6e81e8e35da5754388ddcc6d0d14b6c6a132cb93d69ed580a7278c"
  end

  resource "bittensor-drand" do
    url "https://files.pythonhosted.org/packages/36/13/36a587abc84cfa5a855879e247c3a763fe05cae02ff007f71f895ec933e2/bittensor_drand-1.3.0.tar.gz"
    sha256 "ec3694c2226d66e2637168c8b31082d5cbbf991e350c254e340e1eb0255142fd"
  end

  resource "bittensor-wallet" do
    url "https://files.pythonhosted.org/packages/74/69/8e5eb1131e3fb750ead1c1b1d2b628dede7b41edfad835cb78764dd88ceb/bittensor_wallet-4.0.1.tar.gz"
    sha256 "edc2588d5e272835285e4171dd3daf862149f617015bf52e43d433d8e5c297c5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "cyscale" do
    url "https://files.pythonhosted.org/packages/c8/26/58ac0791e64f711ff2999f532737e4de5a2b4a5fb1e2150302e1c4b7bacd/cyscale-0.3.3.tar.gz"
    sha256 "e1d1f2fc95ef4b1bfb6ebabc72121ec519a0d996e74d905fc0d6142ec4f8694d"
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
    url "https://files.pythonhosted.org/packages/e1/63/210aaa302d6a0a78daa67c5c15bbac2cad361722841278b0209b6da20855/gitpython-3.1.49.tar.gz"
    sha256 "42f9399c9eb33fc581014bedd76049dfbaf6375aa2a5754575966387280315e1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ce/cc/762dfb036166873f0059f3b7de4565e1b5bc3d6f28a414c13da27e442f99/idna-3.13.tar.gz"
    sha256 "585ea8fe5d69b9181ec1afba340451fba6ba764af97026f92a91d4eef164a242"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/a2/f7/139d22fef48ac78127d18e01d80cf1be40236ae489769d17f35c3d425293/more_itertools-11.0.2.tar.gz"
    sha256 "392a9e1e362cbc106a2457d37cabf9b36e5e12efd4ebff1654630e76597df804"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "narwhals" do
    url "https://files.pythonhosted.org/packages/e9/f3/257adc69a71011b4c8cda321b00f02c5bf1980ae38ffd05a58d9632d4de8/narwhals-2.20.0.tar.gz"
    sha256 "c10994975fa7dc5a68c2cffcddbd5908fc8ebb2d463c5bab085309c0ee1f551e"
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
    url "https://files.pythonhosted.org/packages/3a/7f/0f100df1172aadf88a929a9dbb902656b0880ba4b960fe5224867159d8f4/plotly-6.7.0.tar.gz"
    sha256 "45eea0ff27e2a23ccd62776f77eb43aa1ca03df4192b76036e380bb479b892c6"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/9e/da/e9fc233cf63743258bff22b3dfa7ea5baef7b5bc324af47a0ad89b8ffc6f/propcache-0.4.1.tar.gz"
    sha256 "f48107a8c637e80362555f37ecf49abe20370e557cc4ab374f04ec4423c97c3d"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
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
    url "https://files.pythonhosted.org/packages/e9/67/cae617f1351490c25a4b8ac3b8b63a4dda609295d8222bad12242dfdc629/rich-14.3.4.tar.gz"
    sha256 "817e02727f2b25b40ef56f5aa2217f400c8489f79ca8f46ea2b70dd5e14558a9"
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
    url "https://files.pythonhosted.org/packages/7b/27/ede8cec7596e0041ba7e7b80b47d132562f56ff454313a16f6084e555c9f/typer-0.25.0.tar.gz"
    sha256 "123eaf9f19bb40fd268310e12a542c0c6b4fab9c98d9d23342a01ff95e3ce930"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/04/24/4b2031d72e840ce4c1ccb255f693b15c334757fc50023e4db9537080b8c4/websockets-16.0.tar.gz"
    sha256 "5f6261a5e56e8d5c42a4497b364ea24d94d9563e8fbd44e78ac40879c60179b5"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/39/62/75f18a0f03b4219c456652c7780e4d749b929eb605c098ce3a5b6b6bc081/wheel-0.47.0.tar.gz"
    sha256 "cc72bd1009ba0cf63922e28f94d9d83b920aa2bb28f798a31d0691b02fa3c9b3"
  end

  resource "xxhash" do
    url "https://files.pythonhosted.org/packages/24/2f/e183a1b407002f5af81822bee18b61cdb94b8670208ef34734d8d2b8ebe9/xxhash-3.7.0.tar.gz"
    sha256 "6cc4eefbb542a5d6ffd6d70ea9c502957c925e800f998c5630ecc809d6702bae"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/23/6e/beb1beec874a72f23815c1434518bfc4ed2175065173fb138c3705f658d4/yarl-1.23.0.tar.gz"
    sha256 "53b1ea6ca88ebd4420379c330aea57e258408dd0df9af0992e5de2078dc9f5d5"
  end

  def install
    ENV.O0
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
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
