class Bittensor < Formula
  include Language::Python::Virtualenv

  desc "SDK and command-line tool for the Bittensor network"
  homepage "https://subtensor.vercel.app/"
  url "https://files.pythonhosted.org/packages/4b/6f/2f572aef87a756b18c33bf080a7ad4a8f47c728c9519ec05946c68fba5b9/bittensor-11.3.2.tar.gz"
  sha256 "a25adb9e9ce9614d188e1da9e4c56d1b0eda5d133b32238f7046fe4eb8cd3ee8"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "f8cbd87bd655b6a2733e579ebb7bff016ce5435d71da9a51712eeed9c1804c66"
    sha256 cellar: :any, arm64_tahoe:       "63b5366de84f5e5141d10159086bc5e2bc47b35bd20ab63a2ba15339f8e36aba"
    sha256 cellar: :any, arm64_sequoia:     "e71af8e2d98b5284591be8899e9fcffcb43b347140e10ff079448328d541c2a2"
    sha256 cellar: :any, arm64_linux:       "56a4ee8eeff4adc4d06a4c6a1013abf1ef80b396719c685953f2da28ae538907"
    sha256 cellar: :any, x86_64_linux:      "cb29e721a14c7aa8d3008e3d2ba57cbd682ba879bc36fd5dbc7ba8e2a2ae0ef6"
  end

  depends_on "rust" => :build # for bittensor-core

  depends_on "openssl@4"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"

  conflicts_with "btcli", "btpd", because: "both install `btcli` binaries"

  pypi_packages exclude_packages: %w[pydantic]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/a9/cc/aa09a20048dd650d9a36bd70c26b2688413066d65acc9f484f94b9929108/bitarray-3.12.3.tar.gz"
    sha256 "919e35a951c0a551631b94bf568f3f5e38d004e0c60866cb2ca51bd8c4778fec"
  end

  resource "bittensor-core" do
    # The PyPI sdist omits vendored crates required by the workspace's path patches.
    # https://github.com/RaoFoundation/subtensor/pull/3330
    url "https://github.com/RaoFoundation/subtensor/archive/8b2a978a98c0d94300dd7c68b190b24b974b7d02.tar.gz"
    version "0.1.9"
    sha256 "78a8681608ac0f538eebf219e2aeac6fa543ad10075920b1432caf04cb2f6981"
  end

  resource "ckzg" do
    url "https://files.pythonhosted.org/packages/2b/88/552337d9fc69dc85fb6102c18b73a9f3f77efb39bb9a0c1a8c61bbdd7274/ckzg-2.1.8.tar.gz"
    sha256 "d7bef6b425dca6995457fc59fc5b30211d9b28cbbeee0e7a7bef1372e13f29ca"
  end

  resource "cytoolz" do
    url "https://files.pythonhosted.org/packages/43/ce/d8bd9b5f85b11c7231f7cec791e1248949c8073e9cded5076759d973d35b/cytoolz-1.2.0.tar.gz"
    sha256 "fdd8ded8a93e1be009577fccddaacf78aa21cbe7dc6ec53c229def0198a1ffa5"
  end

  resource "eth-abi" do
    url "https://files.pythonhosted.org/packages/b6/90/8bbcb07308436211a1e9a09a2fbaa259d2a169d3b081ca22525e22d16444/eth_abi-6.0.0.tar.gz"
    sha256 "e83a0ed91f2dadeeb50236d673736fe2edc6fcc0a1c1e13d461192d4b23d5bcc"
  end

  resource "eth-account" do
    url "https://files.pythonhosted.org/packages/74/cf/20f76a29be97339c969fd765f1237154286a565a1d61be98e76bb7af946a/eth_account-0.13.7.tar.gz"
    sha256 "5853ecbcbb22e65411176f121f5f24b8afeeaf13492359d254b16d8b18c77a46"
  end

  resource "eth-hash" do
    url "https://files.pythonhosted.org/packages/3c/f5/c67fc24f2f676aa9b7ab29679d44f113f314c817207cd4319353356f62da/eth_hash-0.8.0.tar.gz"
    sha256 "b009752b620da2e9c7668014849d1f5fadbe4f138603f1871cc5d4ca706896b1"
  end

  resource "eth-keyfile" do
    url "https://files.pythonhosted.org/packages/35/66/dd823b1537befefbbff602e2ada88f1477c5b40ec3731e3d9bc676c5f716/eth_keyfile-0.8.1.tar.gz"
    sha256 "9708bc31f386b52cca0969238ff35b1ac72bd7a7186f2a84b86110d3c973bec1"
  end

  resource "eth-keys" do
    url "https://files.pythonhosted.org/packages/39/58/f54660cffe3f39aad2d80d13b072973ee9134b6cdfd8b4d086419eda997b/eth_keys-0.8.0.tar.gz"
    sha256 "11549b251876fccd7caedd6905e494ea2309aec352ec2579b00ef9978017a964"
  end

  resource "eth-rlp" do
    url "https://files.pythonhosted.org/packages/5f/e1/9719acaa45e6f158ebfc260a97edc71591264c1d09701cf8a30a687a36b0/eth_rlp-3.0.0.tar.gz"
    sha256 "9663e54a4a1c1c847d2d328c1d07e4174ec1c082953fbb42b60e61c501c4931c"
  end

  resource "eth-typing" do
    url "https://files.pythonhosted.org/packages/37/e7/06c5af99ad40494f6d10126a9030ff4eb14c5b773f2a4076017efb0a163a/eth_typing-6.0.0.tar.gz"
    sha256 "315dd460dc0b71c15a6cd51e3c0b70d237eec8771beb844144f3a1fb4adb2392"
  end

  resource "eth-utils" do
    url "https://files.pythonhosted.org/packages/e9/1b/0b8548da7b31eba87ed58bca1d0de5dcb13a6c113e02c09019ec5a6716ed/eth_utils-6.0.0.tar.gz"
    sha256 "eb54b2f82dd300d3142c49a89da195e823f5e5284d43203593f87c67bad92a96"
  end

  resource "hexbytes" do
    url "https://files.pythonhosted.org/packages/27/4f/eabe45c58f2d27cd0b338ecc41b0b475a3751ed70eb1a21db08497e3ceec/hexbytes-2.0.0.tar.gz"
    sha256 "01312fcd5c57e8a8d2d7dd3274dcf84ea50422aff2abcc2d9fd89ad6a32498e5"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "parsimonious" do
    url "https://files.pythonhosted.org/packages/7b/91/abdc50c4ef06fdf8d047f60ee777ca9b2a7885e1a9cea81343fbecda52d7/parsimonious-0.10.0.tar.gz"
    sha256 "8281600da180ec8ae35427a4ab4f7b82bfec1e3d1e52f80cb60ea82b9512501c"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/a9/75/b8a9ba9a15b1b190d1fb21e75e921934c9bcd7e63e137f96b56ed274328c/pycryptodome-3.24.1.tar.gz"
    sha256 "3f9e74444c0ecbec7af232a95d282c74b114d53212ce075ed17b7fd7dca32bb3"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "qrcode" do
    url "https://files.pythonhosted.org/packages/8f/b2/7fc2931bfae0af02d5f53b174e9cf701adbb35f39d69c2af63d4a39f81a9/qrcode-8.2.tar.gz"
    sha256 "35c3f2a4172b33136ab9f6b3ef1c00260dd2f66f858f24d88418a015f446506c"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/f1/54/e3bf7a314a5e5d0bab5455cfcfc7634ca136fc8b249a7c15c829e88b00f2/regex-2026.11.7.tar.gz"
    sha256 "8eedab0d8ac69b0602628bc59ab559d09007ff3bcd92aa740e62b10315403007"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rlp" do
    url "https://files.pythonhosted.org/packages/1e/45/68859ee36a69ddd8fa819d52fab75214de56f05500907e8bf09b5fd7bd75/rlp-5.0.0.tar.gz"
    sha256 "ae8ac791160c160e270f9c7df76e68f4d42bb86a13726d807b9357c312d0bac4"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "toolz" do
    url "https://files.pythonhosted.org/packages/31/6f/ae20c212a07aa2d156c787383d8088a5e045ee39628661edb190c97e1659/toolz-1.2.0.tar.gz"
    sha256 "9667a038e9d6ecba37995e26cb2f59ec6420b6ad8dd9677de59db9b956b08490"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/ad/8f/21021859316f44289101638dc74d82e13d722d8533e4b8708a3ab7c8461a/typer-0.28.0.tar.gz"
    sha256 "69ab84ef79fd601cff071bbd2566d855ecadfd93adbc4b3360b9924359bdd857"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/f7/bc3a25c5ec26ce62ce487690becc2f3710bbc7b33338f005ad390db0b986/websockets-16.1.1.tar.gz"
    sha256 "db234eda965dcce15df96bb9709f587cd87d4d52aaf0e80e2f34ec04c7670c57"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    ENV["OPENSSL_NO_VENDOR"] = "1"

    # Allow Python 3.15
    inreplace "pyproject.toml", 'requires-python = ">=3.10,<3.15"', 'requires-python = ">=3.10,<3.16"'

    venv = virtualenv_install_with_resources without: "bittensor-core"
    resource("bittensor-core").stage do
      venv.pip_install Pathname.pwd/"sdk/bittensor-core-py"
    end

    bin.install_symlink libexec/"bin/btcli"
    bash_completion.install libexec/"share/bash-completion/completions/btcli"
    zsh_completion.install libexec/"share/zsh/site-functions/_btcli"
    fish_completion.install libexec/"share/fish/vendor_completions.d/btcli.fish"
  end

  test do
    wallet_path = testpath/"btcli-brew-test"
    test_wallet_name = "brew-test"
    # Substrate dev seed for //Alice, so the regenerated address is deterministic
    seed = "0xe5be9a5092b81bca64be81d212e7f2f9eba183bb7a90954f7b76361f6edb5c0a"
    ss58_address = "5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY"

    global_args = %W[
      --wallet #{test_wallet_name}
      --wallet-path #{wallet_path}
      --json
    ]
    regen_args = %W[
      --seed #{seed}
      --no-password
      --overwrite
    ]
    output = shell_output("#{bin}/btcli #{global_args.join(" ")} wallet regen-coldkey #{regen_args.join(" ")}")

    assert_equal ss58_address, JSON.parse(output).fetch("ss58")
  end
end
