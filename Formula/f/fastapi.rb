class Fastapi < Formula
  include Language::Python::Virtualenv

  desc "CLI for FastAPI framework"
  homepage "https://fastapi.tiangolo.com/"
  url "https://files.pythonhosted.org/packages/8c/e3/77a2df0946703973b9905fd0cde6172c15e0781984320123b4f5079e7113/fastapi-0.121.0.tar.gz"
  sha256 "06663356a0b1ee93e875bbf05a31fb22314f5bed455afaaad2b2dad7f26e98fa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "521dfdabf8cdf93e27667f44b4f1fbf48c2281a1b68a4f03e8f3a77dae9bdccc"
    sha256 cellar: :any,                 arm64_sequoia: "47181552477e5aabdeaf6501cd6c6b90f84fd6b5b72a98fedbef6fa5413c5939"
    sha256 cellar: :any,                 arm64_sonoma:  "9ca76e49934ff5d9573caf9589e9b9e213d8012198e9964354c0eb01c18e5ff4"
    sha256 cellar: :any,                 sonoma:        "f2e09ed65dfe86d441734a43c32619536eafe5d2ca59c8beb76b4dbd79970e87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffe72eecdabfea73ceccc40fdef0d0e8bde770e1a1a7acac52f9b1e70c05e340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3100cdc335611b9c50f7e564e947fd8263bbff1686431886bbed10f205ecefba"
  end

  depends_on "rust" => :build # for annotated-doc
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic-core" => :no_linkage
  depends_on "python@3.14"

  pypi_packages package_name:     "fastapi[standard]",
                exclude_packages: ["certifi", "pydantic-core"]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/d7/a6/dc46877b911e40c00d395771ea710d5e77b6de7bacd5fdcd78d70cc5a48f/annotated_doc-0.0.3.tar.gz"
    sha256 "e18370014c70187422c33e945053ff4c286f453a984eba84d0dbfa0c935adeda"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/c6/78/7d432127c41b50bccba979505f272c16cbcadcc33645d5fa3a738110ae75/anyio-4.11.0.tar.gz"
    sha256 "82a8d0b81e318cc5ce71a5f1f8b5c4e63619620b63141ef8c995fa0db95a57c4"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
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
    url "https://files.pythonhosted.org/packages/cc/13/11e43d630be84e51ba5510a6da6a11eb93b44b72caa796137c5dddda937b/fastapi_cli-0.0.14.tar.gz"
    sha256 "ddfb5de0a67f77a8b3271af1460489bd4d7f4add73d11fbfac613827b0275274"
  end

  resource "fastapi-cloud-cli" do
    url "https://files.pythonhosted.org/packages/f9/48/0f14d8555b750dc8c04382804e4214f1d7f55298127f3a0237ba566e69dd/fastapi_cloud_cli-0.3.1.tar.gz"
    sha256 "8c7226c36e92e92d0c89827e8f56dbf164ab2de4444bd33aa26b6c3f7675db69"
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

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/f3/1e/4f0a3233767010308f2fd6bd0814597e3f63f1dc98304a9112b8759df4ff/pydantic-2.12.3.tar.gz"
    sha256 "1da1c82b0fc140bb0103bc1441ffe062154c8d38491189751ee00fd8ca65ce74"
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
    url "https://files.pythonhosted.org/packages/f3/87/f44d7c9f274c7ee665a29b885ec97089ec5dc034c7f3fafa03da9e39a09e/python_multipart-0.0.20.tar.gz"
    sha256 "8dd0cab45b8e23064ae09147625994d090fa46f5b0d1e13af944c331a7fa9d13"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "rich-toolkit" do
    url "https://files.pythonhosted.org/packages/67/33/1a18839aaa8feef7983590c05c22c9c09d245ada6017d118325bbfcc7651/rich_toolkit-0.15.1.tar.gz"
    sha256 "6f9630eb29f3843d19d48c3bd5706a086d36d62016687f9d0efa027ddc2dd08a"
  end

  resource "rignore" do
    url "https://files.pythonhosted.org/packages/e9/04/ecf19d701a0c9ddacbe0a01024acc5642045ff68afedd6c6e5822255e0ae/rignore-0.7.4.tar.gz"
    sha256 "84c1c6bdfae8b28ef2c5fa5cc7b08d7e9cf1df1f4079c16bc669da4937634907"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/b3/18/09875b4323b03ca9025bae7e6539797b27e4fc032998a466b4b9c3d24653/sentry_sdk-2.43.0.tar.gz"
    sha256 "52ed6e251c5d2c084224d73efee56b007ef5c2d408a4a071270e82131d336e20"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/de/1a/608df0b10b53b0beb96a37854ee05864d182ddd4b1156a22f1ad3860425a/starlette-0.49.3.tar.gz"
    sha256 "1c14546f299b5901a1ea0e34410575bc33bbd741377a10484a54445588d00284"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/8f/28/7c85c8032b91dbe79725b6f17d2fffc595dff06a35c7a30a37bef73a1ab4/typer-0.20.0.tar.gz"
    sha256 "1aaf6494031793e4876fb0bacfa6a912b551cf43c1e63c800df8b1a866720c37"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/cb/ce/f06b84e2697fef4688ca63bdb2fdf113ca0a3be33f94488f2cadb690b0cf/uvicorn-0.38.0.tar.gz"
    sha256 "fd97093bdd120a2609fc0d3afe931d4d4ad688b6e75f0f929fde1bc36fe0e91d"
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
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/fastapi"
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

    pid = fork do
      exec bin/"fastapi", "dev", "--port", port.to_s, "main.py"
    end

    sleep 12
    sleep 12 if OS.mac? && Hardware::CPU.intel?
    output = shell_output("curl -s http://127.0.0.1:#{port}")
    assert_equal '{"Hello":"World"}', output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
