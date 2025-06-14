class Btcli < Formula
  include Language::Python::Virtualenv

  desc "Bittensor command-line tool"
  homepage "https://docs.bittensor.com/btcli"
  url "https://files.pythonhosted.org/packages/55/cd/66e342138323b5943105185296eca8da3f794cacba5d5b2373a334e22520/bittensor_cli-9.6.0.tar.gz"
  sha256 "f0528142800aeb8841b2c9556d0f6db86c22554c96eaded228c2dabf5b7e7ea4"
  license "MIT"
  head "https://github.com/opentensor/btcli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7a855c3b77bc12b92d18e3bb279885368adbc44d137109d0e7cb7289a926197b"
    sha256 cellar: :any,                 arm64_sonoma:  "c2a6d8207d25da2ea01199c9b2772bc0c1e130eccf3513c3f464e70280c715dd"
    sha256 cellar: :any,                 arm64_ventura: "9f5187a2f102d812739f1660610bc0ca4a2e20316c139b2765ee23cf9e8c6fb4"
    sha256 cellar: :any,                 sonoma:        "50e99fac804d53b59676963cfdb999b15a72fb048e8e95da99a9055f2aaf72a0"
    sha256 cellar: :any,                 ventura:       "c95abb5c50538b523f1d808f2f10bf712209703a3e25efbcbb2d21cfe7c4ea55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fa7eabc4a7d131ff0d2652e92ad796e3faffccd923674e38b143f5ccddcd64b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6a2a5fe0b58e2d402e67e3d3b75a5cf2e9fef272e5314c27b1f1c609d686304"
  end

  depends_on "cmake" => :build # for Levenshtein
  depends_on "maturin" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "certifi"
  depends_on "cffi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "openssl@3"
  depends_on "pycparser"
  depends_on "python@3.13"
  depends_on "six"

  uses_from_macos "libffi"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/f2/84/ea27e6ad14747d8c51afe201fb88a5c8282b6278256d30a6f71f730add88/aiohttp-3.12.12.tar.gz"
    sha256 "05875595d2483d96cb61fa9f64e75262d7ac6251a7e3c811d8e26f7d721760bd"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ba/b5/6d55e80f6d8a08ce22b982eafa278d823b541c925f11ee774b0b9c43473d/aiosignal-1.3.2.tar.gz"
    sha256 "a8c255c66fafb1e499c9351d0bf32ff2d8a0321595ebac3b93713656d2436f54"
  end

  resource "async-substrate-interface" do
    url "https://files.pythonhosted.org/packages/0e/22/1754349acf82b9f65154d774bc32ac4c87f7da730a38be534a5d54c5ca70/async_substrate_interface-1.3.1.tar.gz"
    sha256 "86dcfdeb94c7b8aab8ef3f870c23d6349c107ab853acc88c44fa1635a6792ef5"
  end

  resource "asyncstdlib" do
    url "https://files.pythonhosted.org/packages/50/e1/72e388631c85233a2fd890d024fc20a8a9961dbba8614d78266636218f1f/asyncstdlib-3.13.1.tar.gz"
    sha256 "f47564b9a3566f8f9172631d88c75fe074b0ce2127963b7265d310df9aeed03a"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "base58" do
    url "https://files.pythonhosted.org/packages/7f/45/8ae61209bb9015f516102fa559a2914178da1d5868428bd86a1b4421141d/base58-2.1.1.tar.gz"
    sha256 "c5d0cb3f5b6e81e8e35da5754388ddcc6d0d14b6c6a132cb93d69ed580a7278c"
  end

  resource "bittensor-wallet" do
    url "https://files.pythonhosted.org/packages/01/a1/e80b2785821f4acfd37cfff74599cc66752a796f5f92e37b9358970e144f/bittensor_wallet-3.0.10.tar.gz"
    sha256 "06af94c589cff82d3ec039c9b2c2829ad048b44410292e710af86a9baa77833e"
  end

  resource "bt-decode" do
    url "https://files.pythonhosted.org/packages/76/d4/cbbe3201561b1467e53bb5a111d968d3364d58633c58009343db9a5c2915/bt_decode-0.6.0.tar.gz"
    sha256 "05e67b5ab018af7a31651bb9c0fb838c3a1733806823019d14c287922869f84e"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/79/b1/b64018016eeb087db503b038296fd782586432b9c077fc5c7839e9cb6ef6/frozenlist-1.7.0.tar.gz"
    sha256 "2e310d81923c2437ea8670467121cc3e9b0f76d3043cc1d2331d56c7fb7a3a8f"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/c0/89/37df0b71473153574a5cdef8f242de422a0f5d26d7a9e231e6f169b4ad14/gitpython-3.1.44.tar.gz"
    sha256 "c87e30b26253bf5418b01b0660f818967f3c503193838337fe5e573331249269"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ce/a0/834b0cebabbfc7e311f30b46c8188790a37f89fc8d756660346fe5abfd09/more_itertools-10.7.0.tar.gz"
    sha256 "9fddd5403be01a94b204faadcff459ec3568cf110265d3c54323e1e866ad29d3"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/91/2f/a3470242707058fe856fe59241eee5635d79087100b7042a867368863a27/multidict-6.4.4.tar.gz"
    sha256 "69ee9e6ba214b5245031b76233dd95408a0fd57fdb019ddcc1ead4790932a8e8"
  end

  resource "narwhals" do
    url "https://files.pythonhosted.org/packages/df/d6/168a787b7800d6c89846b791e4f5ee6b94998a80c8c2838a019d3d71984d/narwhals-1.42.1.tar.gz"
    sha256 "50a5635b11aeda98cf9c37e839fd34b0a24159f59a4dfae930290ad698320494"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/54/90/188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229d/netaddr-1.3.0.tar.gz"
    sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "password-strength" do
    url "https://files.pythonhosted.org/packages/db/f1/6165ebcca27fca3f1d63f8c3a45805c2ed8568be4d09219a2aa45e792c14/password_strength-0.0.3.post2.tar.gz"
    sha256 "bf4df10a58fcd3abfa182367307b4fd7b1cec518121dd83bf80c1c42ba796762"
  end

  resource "plotille" do
    url "https://files.pythonhosted.org/packages/8a/73/3f342572f7f916e387e546cc502d6cad35e7162ba0bcde203669e15aa3af/plotille-5.0.0.tar.gz"
    sha256 "99e5ca51a2e4c922ead3a3b0863cc2c6a9a4b3f701944589df10f42ce02ab3dc"
  end

  resource "plotly" do
    url "https://files.pythonhosted.org/packages/ae/77/431447616eda6a432dc3ce541b3f808ecb8803ea3d4ab2573b67f8eb4208/plotly-6.1.2.tar.gz"
    sha256 "4fdaa228926ba3e3a213f4d1713287e69dcad1a7e66cf2025bd7d7026d5014b4"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/a6/16/43264e4a779dd8588c21a70f0709665ee8f611211bdd2c87d952cfa7c776/propcache-0.3.2.tar.gz"
    sha256 "20d7d62e4e7ef05f221e0db2856b979540686342e7dd9973b815599c7057e168"
  end

  # `py-bip39-bindings` is manually updated to 0.2.0 to fix build issue
  resource "py-bip39-bindings" do
    url "https://files.pythonhosted.org/packages/0a/e1/88d75d69d08322555e5fc310d3086df7355942c993abbc0cca50adf93ed9/py_bip39_bindings-0.2.0.tar.gz"
    sha256 "38eac2c2be53085b8c2a215ebf12abcdaefee07bc8e00d7649b6b27399612b83"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a1/53/830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8/rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "scalecodec" do
    url "https://files.pythonhosted.org/packages/bc/7c/703893e7a8751318517a3dd8c0c060b2c30ffa33f4ab5dd6a4ed483f7967/scalecodec-1.2.11.tar.gz"
    sha256 "99a2cdbfccdcaf22bd86b86da55a730a2855514ad2309faef4a4a93ac6cbeb8d"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/44/cd/a040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3b/smmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/c5/8c/7d682431efca5fd290017663ea4588bf6f2c6aad085c7f108c5dbc316e70/typer-0.16.0.tar.gz"
    sha256 "af377ffaee1dbe37ae9440cb4e8f11686ea5ce4e9bae01b84ae7c63b87f1dd3b"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/d1/bc/51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5/typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/8a/98/2d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25c/wheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  resource "xxhash" do
    url "https://files.pythonhosted.org/packages/00/5e/d6e5258d69df8b4ed8c83b6664f2b47d30d2dec551a29ad72a6c69eafd31/xxhash-3.5.0.tar.gz"
    sha256 "84f2caddf951c9cbf8dc2e22a89d4ccf5d86391ac6418fe81e3c67d0cf60b45f"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/3c/fb/efaa23fa4e45537b827620f04cf8f3cd658b76642205162e072703a5b963/yarl-1.20.1.tar.gz"
    sha256 "d017a4997ee50c91fd5466cef416231bb82177b93b029906cefc542ce14c35ac"
  end

  def install
    # required to declare scalecodec's version, issue opened at https://github.com/JAMdotTech/py-scale-codec/issues/130
    ENV["TRAVIS_TAG"] = resource("scalecodec").version.to_s
    # `shellingham` auto-detection doesn't work in Homebrew CI build environment so
    # defer installation to allow `typer` to use argument as shell for completions
    # Ref: https://typer.tiangolo.com/features/#user-friendly-cli-apps
    venv = virtualenv_install_with_resources start_with: ["setuptools", "wheel", "toml"], without: "shellingham"
    generate_completions_from_executable(bin/"btcli", "--show-completion")
    venv.pip_install resource("shellingham")
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
          "coldkey"              => ss58_address,
          "free"                 => 0.0,
          "staked"               => 0.0,
          "staked_with_slippage" => 0.0,
          "total"                => 0.0,
          "total_with_slippage"  => 0.0,
        },
      },
      "totals"   => {
        "free"                 => 0.0,
        "staked"               => 0.0,
        "staked_with_slippage" => 0.0,
        "total"                => 0.0,
        "total_with_slippage"  => 0.0,
      },
    }

    parsed_balance = JSON.parse(balance_output)
    assert_equal expected_balance, parsed_balance
  end
end
