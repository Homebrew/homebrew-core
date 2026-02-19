class Fastapi < Formula
  include Language::Python::Virtualenv

  desc "CLI for FastAPI framework"
  homepage "https://fastapi.tiangolo.com/"
  url "https://files.pythonhosted.org/packages/48/47/75f6bea02e797abff1bca968d5997793898032d9923c1935ae2efdece642/fastapi-0.129.0.tar.gz"
  sha256 "61315cebd2e65df5f97ec298c888f9de30430dd0612d59d6480beafbc10655af"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "971439873765775760221b5b18a8ee825777139aced14b2683f2da40ff798bcd"
    sha256 cellar: :any,                 arm64_sequoia: "8d2977be1b7751250b7555e63f35c210912e64cab997e3bffb58d5e40fdba352"
    sha256 cellar: :any,                 arm64_sonoma:  "658d0d6b9072e742a6a0d95b3baddb879a596836407bd107f540edc76adf6e61"
    sha256 cellar: :any,                 sonoma:        "1d343efc7f25aac9615c22e48c4477dbd1bd6d553850064e0c7ca32a3a295ca7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7a6b0ae973641ade361cdd40aff6cbea328b54e7b030988fa79ac53be370d50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ffcff5d396ba31ad1c16c96fbdb14a54efada6f793a076feb01e7a9d085a926"
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
    url "https://files.pythonhosted.org/packages/96/f0/5eb65b2bb0d09ac6776f2eb54adee6abe8228ea05b20a5ad0e4945de8aac/anyio-4.12.1.tar.gz"
    sha256 "41cfcc3a4c85d3f05c932da7c26d0201ac36f72abd4435ba90d0464a3ffed703"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
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
    url "https://files.pythonhosted.org/packages/4a/5a/500ec4deaa9a5d6bc7909cbd7b252fa37fe80d418c55a65ce5ed11c53505/fastapi_cli-0.0.21.tar.gz"
    sha256 "457134b8f3e08d2d203a18db923a18bbc1a01d9de36fbe1fa7905c4d02a0e5c0"
  end

  resource "fastapi-cloud-cli" do
    url "https://files.pythonhosted.org/packages/11/15/6c3d85d63964340fde6f36cc80f3f365d35f371e6a918d68ff3a3d588ef2/fastapi_cloud_cli-0.11.0.tar.gz"
    sha256 "ecc83a5db106be35af528eccb01aa9bced1d29783efd48c8c1c831cf111eea99"
  end

  resource "fastar" do
    url "https://files.pythonhosted.org/packages/69/e7/f89d54fb04104114dd0552836dc2b47914f416cc0e200b409dd04a33de5e/fastar-0.8.0.tar.gz"
    sha256 "f4d4d68dbf1c4c2808f0e730fac5843493fc849f70fe3ad3af60dfbaf68b9a12"
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
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
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
    url "https://files.pythonhosted.org/packages/fd/35/2fee58b1316a73e025728583d3b1447218a97e621933fc776fb8c0f2ebdd/pydantic_extra_types-2.11.0.tar.gz"
    sha256 "4e9991959d045b75feb775683437a97991d02c138e00b59176571db9ce634f0e"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/43/4b/ac7e0aae12027748076d72a8764ff1c9d82ca75a7a52622e67ed3f765c54/pydantic_settings-2.12.0.tar.gz"
    sha256 "005538ef951e3c2a68e1c08b292b5f2e71490def8589d4221b95dab00dafcfd0"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f0/26/19cadc79a718c5edbec86fd4919a6b6d3f681039a2f6d66d14be94e75fb9/python_dotenv-1.2.1.tar.gz"
    sha256 "42667e897e16ab0d66954af0e60a9caa94f0fd4ecf3aaf6d2d260eec1aa36ad6"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/94/01/979e98d542a70714b0cb2b6728ed0b7c46792b695e3eaec3e20711271ca3/python_multipart-0.0.22.tar.gz"
    sha256 "7340bef99a7e0032613f56dc36027b959fd3b30a787ed62d310e951f7c3a3a58"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/74/99/a4cab2acbb884f80e558b0771e97e21e939c5dfb460f488d19df485e8298/rich-14.3.2.tar.gz"
    sha256 "e712f11c1a562a11843306f5ed999475f09ac31ffb64281f73ab29ffdda8b3b8"
  end

  resource "rich-toolkit" do
    url "https://files.pythonhosted.org/packages/d0/c9/4bbf4bfee195ed1b7d7a6733cc523ca61dbfb4a3e3c12ea090aaffd97597/rich_toolkit-0.19.4.tar.gz"
    sha256 "52e23d56f9dc30d1343eb3b3f6f18764c313fbfea24e52e6a1d6069bec9c18eb"
  end

  resource "rignore" do
    url "https://files.pythonhosted.org/packages/e5/f5/8bed2310abe4ae04b67a38374a4d311dd85220f5d8da56f47ae9361be0b0/rignore-0.7.6.tar.gz"
    sha256 "00d3546cd793c30cb17921ce674d2c8f3a4b00501cb0e3dd0e82217dbeba2671"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/59/eb/1b497650eb564701f9a7b8a95c51b2abe9347ed2c0b290ba78f027ebe4ea/sentry_sdk-2.52.0.tar.gz"
    sha256 "fa0bec872cfec0302970b2996825723d67390cdd5f0229fb9efed93bd5384899"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/c4/68/79977123bb7be889ad680d79a40f339082c1978b5cfcf62c2d8d196873ac/starlette-0.52.1.tar.gz"
    sha256 "834edd1b0a23167694292e94f597773bc3f89f362be6effee198165a35d62933"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/7e/e6/44e073787aa57cd71c151f44855232feb0f748428fd5242d7366e3c4ae8b/typer-0.23.0.tar.gz"
    sha256 "d8378833e47ada5d3d093fa20c4c63427cc4e27127f6b349a6c359463087d8cc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/c3/d1/8f3c683c9561a4e6689dd3b1d345c815f10f86acd044ee1fb9a4dcd0b8c5/uvicorn-0.40.0.tar.gz"
    sha256 "839676675e87e73694518b5574fd0f24c9d97b46bea16df7b8c05ea1a51071ea"
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
