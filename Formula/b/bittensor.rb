class Bittensor < Formula
  include Language::Python::Virtualenv

  desc "SDK and command-line tool for the Bittensor network"
  homepage "https://subtensor.vercel.app/"
  url "https://files.pythonhosted.org/packages/00/14/51265fd57e4d6ca662cf8ad28c7b92bcd5ca50ce171e544fe2ab537dfbbe/bittensor-11.0.0.tar.gz"
  sha256 "b53c5030d88fac9888f7acbca8069985d7f609021ce634c11f5db14af4e788d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4c5a66fe6ca1f0151fe04d1c82a5b364f0c7a7f613a9403218ce7bfecfb97556"
    sha256 cellar: :any, arm64_sequoia: "a15a4ffdc279b019aed6f965034c6e7786fe158d7d148f989fd42f2d73466ba7"
    sha256 cellar: :any, arm64_sonoma:  "1639ad309dba5716818db48d54c75159960d5892382890535c042a3aaa80a60e"
    sha256 cellar: :any, sonoma:        "2e2fbbfef8e4a31ac9b17abc207614523a2accf1c2e4978f9fc0fc868d0eedc3"
    sha256 cellar: :any, arm64_linux:   "d9076b615d9df8c94ab05bb62dcb8110dd661e9938a5c9b60ed689dbeb2f7f55"
    sha256 cellar: :any, x86_64_linux:  "fcccef711ab62e272d4ccc4d576f24b04911af2c682f173a1f0251f9d6547ddb"
  end

  depends_on "rust" => :build # for bittensor-core

  depends_on "openssl@3"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.13" # upstream requires-python is `>=3.10,<3.14`, issue ref: https://github.com/RaoFoundation/subtensor/issues/2950

  conflicts_with "btcli", "btpd", because: "both install `btcli` binaries"

  pypi_packages exclude_packages: %w[pydantic],
                extra_packages:   %w[eth-abi<6] # FIXME: eth-abi 6.0.0b1 is a pre-release

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/04/eb/e97abd6b7c2245e19be529f6fd70c7dda04c449f4a11b6ddb30079d71ea6/bitarray-3.9.0.tar.gz"
    sha256 "af5f91e61d868c8f457f66cd726ef31d69264f71edbaccd70fdbb13548c1d652"
  end

  resource "bittensor-core" do
    url "https://files.pythonhosted.org/packages/89/32/6da6e44aa3ec7283fd75376f0f5cbc0601dc007c5d91b07d167df92b9861/bittensor_core-0.1.0.tar.gz"
    sha256 "dd7cd31b0ca7cb3d236bb6bb66827f81be054d502e223ff8a440cffd3f03db29"
  end

  resource "ckzg" do
    url "https://files.pythonhosted.org/packages/2b/88/552337d9fc69dc85fb6102c18b73a9f3f77efb39bb9a0c1a8c61bbdd7274/ckzg-2.1.8.tar.gz"
    sha256 "d7bef6b425dca6995457fc59fc5b30211d9b28cbbeee0e7a7bef1372e13f29ca"
  end

  resource "cytoolz" do
    url "https://files.pythonhosted.org/packages/bd/d4/16916f3dc20a3f5455b63c35dcb260b3716f59ce27a93586804e70e431d5/cytoolz-1.1.0.tar.gz"
    sha256 "13a7bf254c3c0d28b12e2290b82aed0f0977a4c2a2bf84854fcdc7796a29f3b0"
  end

  resource "eth-abi" do
    url "https://files.pythonhosted.org/packages/00/71/d9e1380bd77fd22f98b534699af564f189b56d539cc2b9dab908d4e4c242/eth_abi-5.2.0.tar.gz"
    sha256 "178703fa98c07d8eecd5ae569e7e8d159e493ebb6eeb534a8fe973fbc4e40ef0"
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
    url "https://files.pythonhosted.org/packages/58/11/1ed831c50bd74f57829aa06e58bd82a809c37e070ee501c953b9ac1f1552/eth_keys-0.7.0.tar.gz"
    sha256 "79d24fd876201df67741de3e3fefb3f4dbcbb6ace66e47e6fe662851a4547814"
  end

  resource "eth-rlp" do
    url "https://files.pythonhosted.org/packages/7f/ea/ad39d001fa9fed07fad66edb00af701e29b48be0ed44a3bcf58cb3adf130/eth_rlp-2.2.0.tar.gz"
    sha256 "5e4b2eb1b8213e303d6a232dfe35ab8c29e2d3051b86e8d359def80cd21db83d"
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
    url "https://files.pythonhosted.org/packages/7f/87/adf4635b4b8c050283d74e6db9a81496063229c9263e6acc1903ab79fbec/hexbytes-1.3.1.tar.gz"
    sha256 "a657eebebdfe27254336f98d8af6e2236f3f83aed164b87466b6cf6c5f5a4765"
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
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/7b/37/451aaddbf50922f34d744ad5ca919ae1fcfac112123885d9728f52a484b3/regex-2026.7.10.tar.gz"
    sha256 "1050fedf0a8a92e843971120c2f57c3a99bea86c0dfa1d63a9fac053fe54b135"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rlp" do
    url "https://files.pythonhosted.org/packages/1b/2d/439b0728a92964a04d9c88ea1ca9ebb128893fbbd5834faa31f987f2fd4c/rlp-4.1.0.tar.gz"
    sha256 "be07564270a96f3e225e2c107db263de96b5bc1f27722d2855bd3459a08e95a9"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "toolz" do
    url "https://files.pythonhosted.org/packages/11/d6/114b492226588d6ff54579d95847662fc69196bdeec318eb45393b24c192/toolz-1.1.0.tar.gz"
    sha256 "27a5c770d068c110d9ed9323f24f1543e83b2f300a687b7891c1a6d56b697b5b"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/37/78/fda3361b56efc27944f24225f6ecd13d96d6fcfe37bd0eb34e2f4c63f9fc/typer-0.27.0.tar.gz"
    sha256 "629bd12ea5d13a17148125d9a264f949eb171fb3f120f9b04d85873cab054fa5"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/f7/bc3a25c5ec26ce62ce487690becc2f3710bbc7b33338f005ad390db0b986/websockets-16.1.1.tar.gz"
    sha256 "db234eda965dcce15df96bb9709f587cd87d4d52aaf0e80e2f34ec04c7670c57"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    ENV["OPENSSL_NO_VENDOR"] = "1"

    virtualenv_install_with_resources

    bin.install_symlink libexec/"bin/btcli"
    bash_completion.install libexec/"share/bash-completion/completions/btcli"
    zsh_completion.install libexec/"share/zsh/site-functions/_btcli"
    fish_completion.install libexec/"share/fish/vendor_completions.d/btcli.fish"
  end

  test do
    require "json"
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

    expected_regen = {
      "coldkey"     => test_wallet_name,
      "crypto_type" => "sr25519",
      "ss58"        => ss58_address,
      "path"        => wallet_path.to_s,
    }
    assert_equal expected_regen, JSON.parse(output)

    # Check balance of the regenerated wallet on the finney network
    balance_output = shell_output("#{bin}/btcli --network finney #{global_args.join(" ")} wallet balance")
    parsed_balance = JSON.parse(balance_output)
    assert_equal ss58_address, parsed_balance["coldkey"]
    assert_equal 0.0, parsed_balance["free_tao"]
    assert_equal 0.0, parsed_balance["total_value_tao"]
  end
end
