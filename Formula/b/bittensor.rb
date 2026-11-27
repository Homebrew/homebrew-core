class Bittensor < Formula
  include Language::Python::Virtualenv

  desc "SDK and command-line tool for the Bittensor network"
  homepage "https://subtensor.vercel.app/"
  url "https://files.pythonhosted.org/packages/4c/c5/528b81f3a99ec987d511461fbff04e641141d8249fe3b931a3808b663530/bittensor-11.3.7.tar.gz"
  sha256 "63d66aa82e5e34884b0b3328b86a83c17af96d1c3637480ce99927da1e9d3bd4"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "4d0af76dd7abbc5d66093826b4275f491570a746ca9f0a8b3bcfd41a2b6ec28f"
    sha256 cellar: :any, arm64_golden_gate: "bb88aa161a671a320d7ceae3e06f0ef4d6ff57d882d983b62a61e247261d3c93"
    sha256 cellar: :any, arm64_tahoe:       "a1701333932850fc61b29424cfc0a911ba6b7c4f02426fa0a268c7232ad53368"
    sha256 cellar: :any, arm64_sequoia:     "67126e024b396dd8bdab21ddfe56d5452839ffb7eb2f0ca01690b766e5a63bd2"
    sha256 cellar: :any, arm64_linux:       "59b6b8da2b9aaf77febea8545e0e1b213a1148f3497e0991c9aba5e0be67619a"
    sha256 cellar: :any, x86_64_linux:      "2a6a4235086fa331441deb81a79139ef56c923243394c67ff16007e8691c30d8"
  end

  depends_on "rust" => :build # for bittensor-core

  depends_on "openssl@4"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"

  conflicts_with "btcli", "btpd", because: "both install `btcli` binaries"

  pypi_packages exclude_packages: %w[pydantic]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/0b/7d/bdbf3062e5dae31da8b3de1e3269110beb93d268df4a7f6d22b167c6cee0/annotated_doc-0.0.7.tar.gz"
    sha256 "0a30ef8f5322a4173720ae6712dc9a5e58f5a19868f3f167b4b5778db066c2b5"
  end

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/2b/1f/7ba6857992322cca8f379a4858a864f1c05fd1c115e3b1b65000d28ce094/bitarray-3.12.4.tar.gz"
    sha256 "1f8bdf27eea32ab5783e32d3df105bab429e8097adc95d6307635238cfb5d366"
  end

  resource "bittensor-core" do
    url "https://files.pythonhosted.org/packages/f0/d1/436a6f0356abd6194aab2d417702689d1fd0002e4aa7311e23e503a4f1c4/bittensor_core-0.1.14.tar.gz"
    sha256 "a7b85e2ffc2818bd624c7c3938ea61de2d844bfd9be2f08c983b5499ce895c07"
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
    url "https://files.pythonhosted.org/packages/16/fc/cee2c45553c9a9bf77d8b0c391560c556d7ed756b1f0bb35eb5d48db09ea/markdown_it_py-4.3.0.tar.gz"
    sha256 "91a58fa5b72c71a40cf7177250fd767480d7a2bb3ac426ccfb76fb90305fdaaa"
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
    url "https://files.pythonhosted.org/packages/fa/b8/61d96601b737305a04161da340499cbb3299029d4ea0f9c717bc35977c2b/regex-2026.11.25.tar.gz"
    sha256 "d3ea8d9698f13f3fd08c65f9bed0bb07bcfff80b61dfa14d86b8cc398f886588"
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
    url "https://files.pythonhosted.org/packages/f4/8f/4583099c74623e04610d9df01ff58a9217935e88fdbd4b14167ebe99c134/typer-0.29.3.tar.gz"
    sha256 "8189a53bb9684dc551e0b61e71904b323214884f2eb14bfe71aa859ae980d10a"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/f7/bc3a25c5ec26ce62ce487690becc2f3710bbc7b33338f005ad390db0b986/websockets-16.1.1.tar.gz"
    sha256 "db234eda965dcce15df96bb9709f587cd87d4d52aaf0e80e2f34ec04c7670c57"
  end

  allow_network_access! [:build, :test]

  def install
    ENV["OPENSSL_DIR"] = dep("openssl").opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    # Allow Python 3.15
    inreplace "pyproject.toml", 'requires-python = ">=3.10,<3.15"', 'requires-python = ">=3.10,<3.16"'

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.reject { |r| r.name == "bittensor-core" }
    resource("bittensor-core").stage do
      # The sdist keeps `[patch]` entries pointing at vendored crates it does not ship, which breaks `cargo metadata`
      inreplace "Cargo.toml", %r{^(?:evm-gasometer|sc-informant|hickory-proto-\d+) = \{ path = "vendor/.*\n}, ""
      venv.pip_install Pathname.pwd
    end
    venv.pip_install_and_link buildpath

    bin.install_symlink libexec/"bin/btcli"
    bash_completion.install libexec/"share/bash-completion/completions/btcli"
    zsh_completion.install libexec/"share/zsh/site-functions/_btcli"
    fish_completion.install libexec/"share/fish/vendor_completions.d/btcli.fish"
  end

  test do
    wallet_path = testpath/"btcli-brew-test"
    test_wallet_name = "brew-test"
    # Substrate dev seed for //Alice, so the regenerated address is deterministic
    seed = "0xc4fd09cd875228709b3dfca51e1dfc720fdff2c077bacb5aa06ae210eccfa123"
    ss58_address = "5DCrxt3ao2zgdBs3hgAhVZrqJq4KPJo1N9BBTaeJ32T7AaHX"

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
      "coldkey"        => test_wallet_name,
      "crypto_type"    => "sr25519",
      "account_type"   => "standard",
      "signing_scheme" => "sr25519",
      "ss58"           => ss58_address,
      "path"           => wallet_path.to_s,
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
