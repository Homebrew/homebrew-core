class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/8a/c1/8801d7646a0fd0eea9b1afa047013b6887f29260fd5886b23d15df52c782/glances-4.5.4.tar.gz"
  sha256 "c7fca4ff414d6a2e177fdc5998b982da8bbe8e77168ef0471d4d8f4b6d47b025"
  license "LGPL-3.0-or-later"
  revision 3
  head "https://github.com/nicolargo/glances.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2e23d28cd1bdc5ee815d5103c84fcd68360d932bb5a922952fc6cb6bf280a7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ea9ec4f4d89bc009d6508310a0f0225c9bf2f24998dbfb8bbccda4f2e97a7f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1e55d6779fde7ab242fccaa467b659cde2a130f2f9676c3dc7bb8b25a09ecff"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcd891b667e6c3ff7a928c761cfbbf5eea6aa09043833d5d58aa178e31532ab5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cb372b69a44b195c54da08aeeca589f0d63f23fc90d2d313b9d6c15baba0309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "670dfc6c8e47f419466dda3355ebb11ace47ee7072fb78949baed40068b7a90d"
  end

  depends_on "rust" => :build # for annotated-docs
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages package_name:     "glances[containers,web]",
                exclude_packages: %w[certifi cryptography pydantic],
                extra_packages:   "psutil"

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/9b/98/518d8e5081007684232226f475082b30087d0f585e8457db087298259f49/click-8.4.1.tar.gz"
    sha256 "918b5633eddf6b41c32d4f454bf0de810065c74e3f7dbf8ee5452f8be88d3e96"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/25/ca/8de7744cb3bc966c85430ca2d0fcaeea872507c6a4cf6e007f7fe269ed9d/ecdsa-0.19.2.tar.gz"
    sha256 "62635b0ac1ca2e027f82122b5b81cb706edc38cd91c63dda28e4f3455a2bf930"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/5d/45/c130091c2dfa061bbfe3150f2a5091ef1adf149f2a8d2ae769ecaf6e99a2/fastapi-0.136.1.tar.gz"
    sha256 "7af665ad7acfa0a3baf8983d393b6b471b9da10ede59c60045f49fbc89a0fa7f"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/1a/88/bcf9709822fe69d02c2a6a77956c98ce6ea8ca8767a9aadcedc7eb6a2390/idna-3.16.tar.gz"
    sha256 "d7a6da03db833450fca25d2358ac9ff06cd624577a4aea3a596d5c0f77b8e03d"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "podman" do
    url "https://files.pythonhosted.org/packages/18/f1/ea8988ff2085d1a898f7f27b7fa26a5b5e296949c6ef4df26ebc2be1aac0/podman-5.8.0.tar.gz"
    sha256 "bc39b77f4a6a0598bbe860d199e0d54ef2ec551131ae7eab66f0557c43331fb3"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/5c/5f/6583902b6f79b399c9c40674ac384fd9cd77805f9e6205075f828ef11fb2/pyasn1-0.6.3.tar.gz"
    sha256 "697a8ecd6d98891189184ca1fa05d1bb00e2f84b5977c481452050549c8a72cf"
  end

  resource "pyinstrument" do
    url "https://files.pythonhosted.org/packages/32/7f/d3c4ef7c43f3294bd5a475dfa6f295a9fee5243c292d5c8122044fa83bcb/pyinstrument-5.1.2.tar.gz"
    sha256 "af149d672da9493fa37334a1cc68f7b80c3e6cb9fd99b9e426c447db5c650bf0"
  end

  resource "pylxd" do
    url "https://files.pythonhosted.org/packages/23/b2/ed81d9cebf8c81b0f76db47cc8cf844475cb11aa1963b8cd87e11fd2fce9/pylxd-2.4.1.tar.gz"
    sha256 "db539951d1e593e562315ec90031f6635020e2a7174f8328a63207e8db854c15"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-jose" do
    url "https://files.pythonhosted.org/packages/c6/77/3a1c9039db7124eb039772b935f2244fbb73fc8ee65b9acf2375da1c07bf/python_jose-3.5.0.tar.gz"
    sha256 "fb4eaa44dbeb1c26dcc69e4bd7ec54a1cb8dd64d3b4d81ef08d90ff453f2b01b"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/da/8a/22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4/rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/b0/7a/7f131b6082d8b592c32e4312d0a6da3d0b28b8f0d305ddd93e49c9d89929/shtab-1.8.0.tar.gz"
    sha256 "75f16d42178882b7f7126a0c2cb3c848daed2f4f5a276dd1ded75921cc4d073a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/08/a3/84e821cc54b4ab50ae6dbc6ac3800a651b65ec35f045cc73785380654057/starlette-1.0.1.tar.gz"
    sha256 "512399c5f1de7fac99c88572212ded9ddeddef2fb32afa82d724000e88b38f4f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/f6/b1/8e7077a8641086aea449e1b5752a570f1b5906c64e0a33cd6d93b63a066b/uvicorn-0.47.0.tar.gz"
    sha256 "7c9a0ea1a9414106bbab7324609c162d8fa0cdcdcb703060987269d77c7bb533"
  end

  resource "ws4py" do
    url "https://files.pythonhosted.org/packages/cb/55/dd8a5e1f975d1549494fe8692fc272602f17e475fe70de910cdd53aec902/ws4py-0.6.0.tar.gz"
    sha256 "9f87b19b773f0a0744a38f3afa36a803286dd3197f0bb35d9b75293ec7002d19"
  end

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin/"glances", "--print-completion", shells: [:bash, :zsh])
    # Workaround limited netifaces2 functionality on macOS
    # https://github.com/nicolargo/glances/issues/3219
    inreplace libexec/"share/doc/glances/glances.conf", /(port_default_gateway)=True/, "\\1=False" if OS.mac?
  end

  test do
    require "pty"
    PTY.spawn bin/"glances", "-q", "--export", "csv", "--export-csv-file", "/dev/stdout" do |r, _w, pid|
      assert_match "timestamp", r.gets
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
