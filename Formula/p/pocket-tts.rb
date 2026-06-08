class PocketTts < Formula
  include Language::Python::Virtualenv

  desc "Text-to-speech application designed to run efficiently on CPUs"
  homepage "https://github.com/kyutai-labs/pocket-tts"
  url "https://files.pythonhosted.org/packages/f9/2c/7445f57163bb40e2b2fab4df70d18a4216c4965cdf74196344d95859fc07/pocket_tts-2.1.0.tar.gz"
  sha256 "6f244f445413400f686506f5ccfb75048547caab7b455b927f4a854c551c60a8"
  license "MIT"
  revision 2
  head "https://github.com/kyutai-labs/pocket-tts.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "999d0375de97143af229af7727d0010ce7f8aeecccd78354ab2dd59d691efeba"
    sha256 cellar: :any,                 arm64_sequoia: "cf7abfb3717d8957e84902d249992f8678e95d5a2b52bc56f23b1b7e63ff3b93"
    sha256 cellar: :any,                 arm64_sonoma:  "b70a3af73113f06d39c67678fcc1aa7de32b4b8e2b849bad15b70cd9f65a36dd"
    sha256 cellar: :any,                 sonoma:        "86cc8a8cb419b9355cb85339a3a46e3aa305f4060a6aa7c71b42f876b70f1c7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27f8a06ef88ad2031af7485c37a5108bfff26b53ae999b5badbff14cf2bc6105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b7a5a79aa4defe142137f8ed23e4c3b109e8f5dc768ca673c2f61f41adda194"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build # for hf-xet
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "pytorch"
  depends_on "scipy" => :no_linkage

  on_linux do
    depends_on "openssl@3" # for hf-xet
  end

  pypi_packages exclude_packages: %w[certifi pydantic scipy torch]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "beartype" do
    url "https://files.pythonhosted.org/packages/c7/94/1009e248bbfbab11397abca7193bea6626806be9a327d399810d523a07cb/beartype-0.22.9.tar.gz"
    sha256 "8f82b54aa723a2848a56008d18875f91c1db02c32ef6a62319a002e3e25a975f"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/9b/98/518d8e5081007684232226f475082b30087d0f585e8457db087298259f49/click-8.4.1.tar.gz"
    sha256 "918b5633eddf6b41c32d4f454bf0de810065c74e3f7dbf8ee5452f8be88d3e96"
  end

  resource "einops" do
    url "https://files.pythonhosted.org/packages/2c/77/850bef8d72ffb9219f0b1aac23fbc1bf7d038ee6ea666f331fa273031aa2/einops-0.8.2.tar.gz"
    sha256 "609da665570e5e265e27283aab09e7f279ade90c4f01bcfca111f3d3e13f2827"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/5d/45/c130091c2dfa061bbfe3150f2a5091ef1adf149f2a8d2ae769ecaf6e99a2/fastapi-0.136.1.tar.gz"
    sha256 "7af665ad7acfa0a3baf8983d393b6b471b9da10ede59c60045f49fbc89a0fa7f"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/74/d8/5c06fc76461418326a7decf8367480c35be11a41fd938633929c60a9ec6b/hf_xet-1.5.0.tar.gz"
    sha256 "e0fb0a34d9f406eed88233e829a67ec016bec5af19e480eac65a233ea289a948"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/48/0f/ed994dbade67a54407c28cab96ef845e0e6d25500be56aca6394f8bfc9dd/huggingface_hub-1.16.1.tar.gz"
    sha256 "7f1dc4c5ec21aed69be630ad0c3378616be16f3de1a47b141c0e812965d9c832"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/1a/88/bcf9709822fe69d02c2a6a77956c98ce6ea8ca8767a9aadcedc7eb6a2390/idna-3.16.tar.gz"
    sha256 "d7a6da03db833450fca25d2358ac9ff06cd624577a4aea3a596d5c0f77b8e03d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/4e/fe/70bd71a6738b09a0bdf6480ca6436b167469ca4578b2a0efbe390b4b0e70/python_multipart-0.0.29.tar.gz"
    sha256 "643e93849196645e2dbdd81a0f8829a23123ad7f797a84a364c6fb3563f18904"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "safetensors" do
    url "https://files.pythonhosted.org/packages/29/9c/6e74567782559a63bd040a236edca26fd71bc7ba88de2ef35d75df3bca5e/safetensors-0.7.0.tar.gz"
    sha256 "07663963b67e8bd9f0b8ad15bb9163606cd27cc5a1b96235a50d8369803b96b0"
  end

  resource "sentencepiece" do
    url "https://files.pythonhosted.org/packages/15/15/2e7a025fc62d764b151ae6d0f2a92f8081755ebe8d4a64099accc6f77ba6/sentencepiece-0.2.1.tar.gz"
    sha256 "8138cec27c2f2282f4a34d9a016e3374cd40e5c6e9cb335063db66a0a3b71fad"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/08/a3/84e821cc54b4ab50ae6dbc6ac3800a651b65ec35f045cc73785380654057/starlette-1.0.1.tar.gz"
    sha256 "512399c5f1de7fac99c88572212ded9ddeddef2fb32afa82d724000e88b38f4f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/e4/51/9aed62104cea109b820bbd6c14245af756112017d309da813ef107d42e7e/typer-0.25.1.tar.gz"
    sha256 "9616eb8853a09ffeabab1698952f33c6f29ffdbceb4eaeecf571880e8d7664cc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/f6/b1/8e7077a8641086aea449e1b5752a570f1b5906c64e0a33cd6d93b63a066b/uvicorn-0.47.0.tar.gz"
    sha256 "7c9a0ea1a9414106bbab7324609c162d8fa0cdcdcb703060987269d77c7bb533"
  end

  def install
    venv = virtualenv_install_with_resources(without: "hf-xet")

    resource("hf-xet").stage do
      # Use native-tls instead since building bundled aws-lc is tricky to do indirectly within superenv.
      # Can consider switching if system copy is supported https://github.com/aws/aws-lc-rs/issues/936
      inreplace "xet_client/Cargo.toml", 'default = ["rustls-tls"]', 'default = ["native-tls"]'

      if ENV.effective_arch == :armv8
        # Disable sha2-asm which requires a minimum of -march=armv8-a+crypto
        inreplace "xet_data/Cargo.toml",
                  'sha2 = { workspace = true, features = ["asm"] }',
                  "sha2 = { workspace = true }"
      end
      venv.pip_install Pathname.pwd
    end

    # We depend on pytorch, but that's a separate formula, so install a `.pth` file to link them.
    # NOTE: This is an exception to our usual policy as building `pytorch` is complicated
    site_packages = Language::Python.site_packages(venv.root/"bin/python3")
    pth_contents = "import site; site.addsitedir('#{Formula["pytorch"].opt_libexec/site_packages}')\n"
    (venv.site_packages/"homebrew-pytorch.pth").write pth_contents

    generate_completions_from_executable(bin/"pocket-tts", shell_parameter_format: :typer)
  end

  test do
    assert_match "Results written in ./tts_output.wav",
      shell_output("#{bin}/pocket-tts generate 2>&1")
  end
end
