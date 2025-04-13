class KeeperCommander < Formula
  include Language::Python::Virtualenv

  desc "Command-line and SDK interface to Keeper Password Manager"
  homepage "https://docs.keeper.io/en/privileged-access-manager/commander-cli/overview"
  url "https://files.pythonhosted.org/packages/c9/69/76aeeb4824553784e9daa5a862a912a476e8602a8175db64353702bbca08/keepercommander-17.0.12.tar.gz"
  sha256 "d1c07bfbbc56333fad8c8ad3ef94b3e8b974202b5d1ec1f9bc382fcd615f4b83"
  license "MIT"
  head "https://github.com/Keeper-Security/Commander.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "185049a68fe05df2f66c3d026fca0060f494d26057c3199d327ad0a83cbc9d95"
    sha256 cellar: :any,                 arm64_sonoma:  "e29c588b4a3c3be2939069cb9f7a1e7d194d898d139386997c927a7d5c37e097"
    sha256 cellar: :any,                 arm64_ventura: "0dc45aa5d6801c38111bd7443885122ebdc932b3ba15a85dff9e5b7fc3a44730"
    sha256 cellar: :any,                 sonoma:        "ff1ce76ec109dd261b4d24f85e6d669b29cbce30460084594a4c34925a296ddc"
    sha256 cellar: :any,                 ventura:       "993e8d9718c5e3d96f2f06a7fe2de709314f62f773b02738e54edb5a732bda27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "951b88a36989ba4a2ff98f2ed12d2b2ff3b5fd100de8d5d013c48d9e497ef0a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "838b6b9b3cd723e119e9d95a31d07e84e45cc6981de2dbcf2dfc278d38dc389a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build # bcrypt dependencies

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "ffmpeg"
  depends_on "libvpx"
  depends_on "opus"
  depends_on "python@3.13"
  depends_on "srtp"

  on_macos do
    depends_on "openssl@3"
  end

  resource "aioice" do
    url "https://files.pythonhosted.org/packages/33/b6/e2b0e48ccb5b04fe29265e93f14a0915f416e359c897ae87d570566c430b/aioice-0.9.0.tar.gz"
    sha256 "fc2401b1c4b6e19372eaaeaa28fd1bd9cbf6b0e412e48625297c53b495eebd1e"
  end

  resource "aiortc" do
    url "https://files.pythonhosted.org/packages/91/60/7bb59c28c6e65e5d74258d392f531f555f12ab519b0f467ffd6b76650c20/aiortc-1.11.0.tar.gz"
    sha256 "50b9d86f6cba87d95ce7c6b051949208b48f8062b231837aed8f049045f11a28"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "asciitree" do
    url "https://files.pythonhosted.org/packages/2d/6a/885bc91484e1aa8f618f6f0228d76d0e67000b0fdd6090673b777e311913/asciitree-0.3.3.tar.gz"
    sha256 "4aa4b9b649f85e3fcb343363d97564aa1fb62e249677f2e18a96765145cc0f6e"
  end

  resource "av" do
    url "https://files.pythonhosted.org/packages/f8/b6/83129e0337376214b0304893cbf0ad0a54718bb47845517fa5870439ca0b/av-14.2.0.tar.gz"
    sha256 "132b5d52ca262b97b0356e8f48cbbe54d0ac232107a722ab8cc8c0c19eafa17b"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/bb/5d/6d7433e0f3cd46ce0b43cd65e1db465ea024dbb8216fb2404e919c2ad77b/bcrypt-4.3.0.tar.gz"
    sha256 "3a3fd2204178b6d2adcf09cb4f6426ffef54762577a7c9b54c159008cb288c18"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/b5/4a/263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829/dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/eb/cc/4529123364d41f342145f2fd775307eaed817cd22810895dea10e15a4d06/fido2-1.2.0.tar.gz"
    sha256 "e39f95920122d64283fda5e5581d95a206e704fa42846bfa4662f86aa0d3333b"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/19/ae/87802e6d9f9d69adfaedfcfd599266bf386a54d0be058b532d04c794f76d/google_crc32c-1.7.1.tar.gz"
    sha256 "2bff2305f98846f3e825dbeec9ee406f89da7962accdb29356e4eadc251bd472"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "ifaddr" do
    url "https://files.pythonhosted.org/packages/e8/ac/fb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791/ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/08/c1395a292bb23fd03bdf572a1357c5a733d3eecbab877641ceacab23db6e/importlib_metadata-8.6.1.tar.gz"
    sha256 "310b41d755445d74569f993ccfc22838295d9fe005425094fad953d7f15c8580"
  end

  resource "keeper-secrets-manager-core" do
    url "https://files.pythonhosted.org/packages/c4/b2/1e0fe5d7b64ddb98609a16e35ded1234bd2bb48a67bc302facb27adbdda1/keeper_secrets_manager_core-16.6.6.tar.gz"
    sha256 "bda9e733908b34edbac956825fc062e6934894f210d49b0bba1679d167d7be80"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/e1/bd15cb8ffdcfeeb2bdc215de3c3cffca11408d829e4b8416dcfe71ba8854/prompt_toolkit-3.0.50.tar.gz"
    sha256 "544748f3860a2623ca5cd6d2795e7a14f3d0e1c3c9728359013f79877fc89bab"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/c8/8c/cf2ac658216eebe49eaedf1e06bc06cbf6a143469236294a1171a51357c3/protobuf-6.30.2.tar.gz"
    sha256 "35c859ae076d8c56054c25b59e5e59638d86545ed6e2b6efac6be0b6ea3ba048"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/ba/d5/861a7daada160fcf6b0393fb741eeb0d0910b039ad7f0cd56c39afdd4a20/pycryptodomex-3.22.0.tar.gz"
    sha256 "a1da61bacc22f93a91cbe690e3eb2022a03ab4123690ab16c46abb693a9df63d"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/93/a3/698b87a4d4d303d7c5f62ea5fbf7a79cab236ccfbd0a17847b7f77f8163e/pydantic-2.11.1.tar.gz"
    sha256 "442557d2910e75c991c39f4b4ab18963d57b9b55122c8b2a9cd176d8c29ce968"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/b9/05/91ce14dfd5a3a99555fce436318cc0fd1f08c4daa32b3248ad63669ea8b4/pydantic_core-2.33.0.tar.gz"
    sha256 "40eb8af662ba409c3cbf4a8150ad32ae73514cd7cb1f1a2113af39763dd616b3"
  end

  resource "pyee" do
    url "https://files.pythonhosted.org/packages/95/03/1fd98d5841cd7964a27d729ccf2199602fe05eb7a405c1462eb7277945ed/pyee-13.0.0.tar.gz"
    sha256 "b391e3c5a434d1f5118a25615001dbc8f669cf410ab67d04c4d4e07c55481c37"
  end

  resource "pylibsrtp" do
    url "https://files.pythonhosted.org/packages/2e/49/1c5101ecfeda540699e0754dddfc91c401fbf736ebe99d66e59fe3dad2ba/pylibsrtp-0.11.0.tar.gz"
    sha256 "5a8d19b1448baebde5ae3cedfa51f10e8ada3d9d99f43046ced0ecf1c105b8ec"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/9f/26/e25b4a374b4639e0c235527bbe31c0524f26eda701d79456a7e1877f4cc5/pyopenssl-25.0.0.tar.gz"
    sha256 "cd2cef799efa3936bb08e8ccb9433a575722b9dd986023f1cabc4ae64e9dac16"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/30/23/2f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60d/pyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/88/2c/7bb1416c5620485aa793f2de31d3df393d3686aa8a8506d11e10e13c5baf/python_dotenv-1.1.0.tar.gz"
    sha256 "41f90bc6f5f177fb41f53e87666db362025010eb28f60a01c9143bfa33a2b2d5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0e/3e/b00a62db91a83fff600de219b6ea9908e6918664899a2d85db222f4fbf19/typing_extensions-4.13.0.tar.gz"
    sha256 "0a4ac55a5820789d87e297727d229866c9650f6521b64206413c4fbada24d95b"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/82/5c/e6082df02e215b846b4b8c0b887a64d7d08ffaba30605502639d44c06b82/typing_inspection-0.4.0.tar.gz"
    sha256 "9765c87de36671694a67904bf2c96e395be9c6439bb6c87b5142569dcdd65122"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3f/50/bad581df71744867e9468ebd0bcd6505de3b275e06f202c2cb016e3ff56f/zipp-3.21.0.tar.gz"
    sha256 "2c9958f6430a2040341a52eb608ed6dd93ef4392e02ffe219417c1b28b5dd1f4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "keepersecurity.com", shell_output("#{bin}/keeper server")
  end
end
