class MlxLm < Formula
  include Language::Python::Virtualenv

  desc "Run LLMs with MLX"
  homepage "https://github.com/ml-explore/mlx-lm"
  url "https://files.pythonhosted.org/packages/84/94/9a38d6b0c6fcca995b9136c94eb7da1e9c5165652edf228b96b29960fa7a/mlx_lm-0.31.3.tar.gz"
  sha256 "61eb0e3ba09444f77f874aff295401d7ccd20b39495cbbce0c782a15474ce733"
  license "MIT"
  revision 1
  head "https://github.com/ml-explore/mlx-lm.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bf0a0323e11e9c39c336c136124e5f3e7984e724c07076863ebe2d56b7896bce"
    sha256 cellar: :any, arm64_sequoia: "d288a815fa84da5a49bb09139514d66398ba080185c32660c8ff7e50355ad425"
    sha256 cellar: :any, arm64_sonoma:  "68367f3948996b753623f7df55e900da414cefadc2192eed229d6f80d0c96175"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on macos: :ventura
  depends_on "mlx"
  depends_on "numpy"
  depends_on "protobuf"
  depends_on "python@3.14"
  depends_on "sentencepiece"

  pypi_packages exclude_packages: %w[certifi mlx numpy]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/23/e4/796662cd90cf80e3a363c99db2b88e0e394b988a575f60a17e16440cd011/click-8.4.0.tar.gz"
    sha256 "638f1338fe1235c8f4e008e4a8a254fb5c5fbdcbb40ece3c9142ebb78e792973"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/b5/fe/997687a931ab51049acce6fa1f23e8f01216374ea81374ddee763c493db5/filelock-3.29.0.tar.gz"
    sha256 "69974355e960702e789734cb4871f884ea6fe50bd8404051a3530bc07809cf90"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/d5/8d/1c51c094345df128ca4a990d633fe1a0ff28726c9e6b3c41ba65087bba1d/fsspec-2026.4.0.tar.gz"
    sha256 "301d8ac70ae90ef3ad05dcf94d6c3754a097f9b5fe4667d2787aa359ec7df7e4"
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
    url "https://files.pythonhosted.org/packages/bb/b6/e22bd20a25299c34b8c5922c1545a6320825b13906eb0f7298edfd034a0b/huggingface_hub-1.15.0.tar.gz"
    sha256 "28abfdddda3927fd4de6a63cf26ab012498a2c24dae52baf150c5c6edf98a1d5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
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

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/60/fd/5b1491d9e4b586d621c54f4c36b888714164b6875f8d6afa3f9072906a51/protobuf-7.35.0.tar.gz"
    sha256 "a2efd84605f41e559f1881b0912b44099d0a2ac9bf46b3474823f10fb393b0e6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/dc/0e/49aee608ad09480e7fd276898c99ec6192985fa331abe4eb3a986094490b/regex-2026.5.9.tar.gz"
    sha256 "a8234aa23ec39894bfe4a3f1b85616a7032481964a13ac6fc9f10de4f6fca270"
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

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/73/6f/f80cfef4a312e1fb34baf7d85c72d4411afde10978d4657f8cdd811d3ccc/tokenizers-0.22.2.tar.gz"
    sha256 "473b83b915e547aa366d1eee11806deaf419e17be16310ac0a14077f1e28f917"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
  end

  resource "transformers" do
    url "https://files.pythonhosted.org/packages/51/58/7f843608f2e8421f86bb97060b54649be6239ec612b82bf9d41e65c26c00/transformers-5.9.0.tar.gz"
    sha256 "25997cb8fa6053533171634b6162d7df54346530ec2aa9b42bb834e63668c842"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/e4/51/9aed62104cea109b820bbd6c14245af756112017d309da813ef107d42e7e/typer-0.25.1.tar.gz"
    sha256 "9616eb8853a09ffeabab1698952f33c6f29ffdbceb4eaeecf571880e8d7664cc"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    # `tokenizers` and `hf-xet` build PyO3 extensions through maturin.
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup"

    venv = virtualenv_install_with_resources(without: "hf-xet")

    resource("hf-xet").stage do
      # Use native-tls instead since building bundled aws-lc is tricky to do indirectly within superenv.
      # Can consider switching if system copy is supported https://github.com/aws/aws-lc-rs/issues/936
      inreplace "xet_client/Cargo.toml", 'default = ["rustls-tls"]', 'default = ["native-tls"]'

      # Disable sha2-asm which requires a minimum of -march=armv8-a+crypto
      if ENV.effective_arch == :armv8
        inreplace "xet_data/Cargo.toml",
                  'sha2 = { workspace = true, features = ["asm"] }',
                  "sha2 = { workspace = true }"
      end
      venv.pip_install Pathname.pwd
    end
  end

  service do
    run opt_bin/"mlx_lm.server"
    keep_alive true
    working_dir var
    log_path var/"log/mlx-lm.log"
    error_log_path var/"log/mlx-lm.log"
  end

  test do
    port = free_port
    pid = spawn bin/"mlx_lm.server", "--port=#{port}"
    begin
      output = JSON.parse(shell_output("curl --silent --retry 5 --retry-connrefused localhost:#{port}/health"))
      assert_equal "ok", output["status"]
    ensure
      Process.kill "SIGTERM", pid
      Process.wait pid
    end
  end
end
