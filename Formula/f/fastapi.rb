class Fastapi < Formula
  include Language::Python::Virtualenv

  desc "CLI for FastAPI framework"
  homepage "https://fastapi.tiangolo.com/"
  url "https://files.pythonhosted.org/packages/5d/45/c130091c2dfa061bbfe3150f2a5091ef1adf149f2a8d2ae769ecaf6e99a2/fastapi-0.136.1.tar.gz"
  sha256 "7af665ad7acfa0a3baf8983d393b6b471b9da10ede59c60045f49fbc89a0fa7f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8c22bc3a38ca3ab10fdf41833d112374842e6f7b2b8e3839de8789ceeb2cf27"
    sha256 cellar: :any,                 arm64_sequoia: "d93181c765a7d5df9935577b53231cb77fe315444732a5180328d251d29c7166"
    sha256 cellar: :any,                 arm64_sonoma:  "7e3f924704895f0f892356b6779f15cd9bb77291c0040e1fced52d8cb75c0933"
    sha256 cellar: :any,                 sonoma:        "bef27456b4a3f716189e1ebba24543e41dcfb0146b525a42dfa0502292082520"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d333958eb74c014d5df9e2a2a90fc522fa693f96fd63c4a81a81a2ac38e57d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab1ba4e29d8cd530d4d4ef14aae2b6277d2ded56fa24e8edbd3fa3ccc867addb"
  end

  depends_on "rust" => :build # for annotated-doc
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages package_name:     "fastapi[standard]",
                exclude_packages: ["certifi", "pydantic"]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/f5/22/900cb125c76b7aaa450ce02fd727f452243f2e91a61af068b40adba60ea9/email_validator-2.3.0.tar.gz"
    sha256 "9fc05c37f2f6cf439ff414f8fc46d917929974a82244c20eb10231ba60c54426"
  end

  resource "fastapi-cli" do
    url "https://files.pythonhosted.org/packages/6e/58/74797ae9e4610cfa0c6b34c8309096d3b20bb29be3b8b5fbf1004d10fa5f/fastapi_cli-0.0.24.tar.gz"
    sha256 "1afc9c9e21d7ebc8a3ca5e31790cd8d837742be7e4f8b9236e99cb3451f0de00"
  end

  resource "fastapi-cloud-cli" do
    url "https://files.pythonhosted.org/packages/67/79/66567c39c5fab6dbebf9e40b3a3fcb0e2ec359517c87a67434c76b06e60b/fastapi_cloud_cli-0.17.0.tar.gz"
    sha256 "2b6c241b63427023bd1e23b3251f23234aba4b05428b245a050e92db1389823c"
  end

  resource "fastar" do
    url "https://files.pythonhosted.org/packages/03/0f/0aeb3fc50046617702acc0078b277b58367fd62eb727b9ec733ae0e8bbcc/fastar-0.11.0.tar.gz"
    sha256 "aa7f100f7313c03fdb20f1385927ba95671071ba308ad0c1763fef295e1895ce"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httptools" do
    url "https://files.pythonhosted.org/packages/b5/46/120a669232c7bdedb9d52d4aeae7e6c7dfe151e99dc70802e2fc7a5e1993/httptools-0.7.1.tar.gz"
    sha256 "abd72556974f8e7c74a259655924a717a2365b236c882c3f6f8a45fe94703ac9"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
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

  resource "pydantic-extra-types" do
    url "https://files.pythonhosted.org/packages/66/71/dba38ee2651f84f7842206adbd2233d8bbdb59fb85e9fa14232486a8c471/pydantic_extra_types-2.11.1.tar.gz"
    sha256 "46792d2307383859e923d8fcefa82108b1a141f8a9c0198982b3832ab5ef1049"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/42/98/c8345dccdc31de4228c039a98f6467a941e39558da41c1744fbe29fa5666/pydantic_settings-2.14.0.tar.gz"
    sha256 "24285fd4b0e0c06507dd9fdfd331ee23794305352aaec8fc4eb92d4047aeb67d"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/88/71/b145a380824a960ebd60e1014256dbb7d2253f2316ff2d73dfd8928ec2c3/python_multipart-0.0.26.tar.gz"
    sha256 "08fadc45918cd615e26846437f50c5d6d23304da32c341f289a617127b081f17"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-toolkit" do
    url "https://files.pythonhosted.org/packages/42/ba/dae9e3096651042754da419a4042bc1c75e07d615f9b15066d738838e4df/rich_toolkit-0.19.7.tar.gz"
    sha256 "133c0915872da91d4c25d85342d5ec1dfacc69b63448af1a08a0d4b4f23ef46e"
  end

  resource "rignore" do
    url "https://files.pythonhosted.org/packages/e5/f5/8bed2310abe4ae04b67a38374a4d311dd85220f5d8da56f47ae9361be0b0/rignore-0.7.6.tar.gz"
    sha256 "00d3546cd793c30cb17921ce674d2c8f3a4b00501cb0e3dd0e82217dbeba2671"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/26/b3/fb8291170d0e844173164709fc0fa0c221ed75a5da740c8746f2a83b4eb1/sentry_sdk-2.58.0.tar.gz"
    sha256 "c1144d947352d54e5b7daa63596d9f848adf684989c06c4f5a659f0c85a18f6f"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/81/69/17425771797c36cded50b7fe44e850315d039f28b15901ab44839e70b593/starlette-1.0.0.tar.gz"
    sha256 "6a4beaf1f81bb472fd19ea9b918b50dc3a77a6f2e190a12954b25e6ed5eea149"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/83/b8/9ebb531b6c2d377af08ac6746a5df3425b21853a5d2260876919b58a2a4a/typer-0.24.2.tar.gz"
    sha256 "ec070dcfca1408e85ee203c6365001e818c3b7fffe686fd07ff2d68095ca0480"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/1f/93/041fca8274050e40e6791f267d82e0e2e27dd165627bd640d3e0e378d877/uvicorn-0.46.0.tar.gz"
    sha256 "fb9da0926999cc6cb22dc7cd71a94a632f078e6ae47ff683c5c420750fb7413d"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/06/f0/18d39dbd1971d6d62c4629cc7fa67f74821b0dc1f5a77af43719de7936a7/uvloop-0.22.1.tar.gz"
    sha256 "6c84bae345b9147082b17371e3dd5d42775bddce91f885499017f4607fdaf39f"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/c2/c9/8869df9b2a2d6c59d79220a4db37679e74f807c559ffe5265e08b227a210/watchfiles-1.1.1.tar.gz"
    sha256 "a173cb5c16c4f40ab19cecf48a534c409f7ea983ab8fed0741304a1c0a31b3f2"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/04/24/4b2031d72e840ce4c1ccb255f693b15c334757fc50023e4db9537080b8c4/websockets-16.0.tar.gz"
    sha256 "5f6261a5e56e8d5c42a4497b364ea24d94d9563e8fbd44e78ac40879c60179b5"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/fastapi"

    generate_completions_from_executable(bin/"fastapi", shell_parameter_format: :typer)
  end

  test do
    port = free_port

    (testpath/"main.py").write <<~PYTHON
      from fastapi import FastAPI

      app = FastAPI()

      @app.get("/")
      async def read_root():
          return {"Hello": "World"}
    PYTHON

    pid = spawn bin/"fastapi", "dev", "--port", port.to_s, "main.py"
    output = shell_output("curl --silent --retry 5 --retry-connrefused http://127.0.0.1:#{port}")
    assert_equal '{"Hello":"World"}', output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
