class PipAudit < Formula
  include Language::Python::Virtualenv

  desc "Audits Python environments and dependency trees for known vulnerabilities"
  homepage "https://pypi.org/project/pip-audit/"
  url "https://files.pythonhosted.org/packages/cc/7f/28fad19a9806f796f13192ab6974c07c4a04d9cbb8e30dd895c3c11ce7ee/pip_audit-2.9.0.tar.gz"
  sha256 "0b998410b58339d7a231e5aa004326a294e4c7c6295289cdc9d5e1ef07b1f44d"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c04dbedb66f03b3e026a1dab2241b9abe3da270eb3761bcdc786f009a42939b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2abb8a1c828c4ab0c6b7c866e35924b47511fe7bc875d8213a608273db2e2bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d5e88d4e1e7a949be3f0bdb4dea0e93e4615c94a5ecade03e3f572a31da02e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e5b2763f263655dda4daf3f923df01cd742d5bc366c09b639d7f5d2be558c4e"
    sha256 cellar: :any_skip_relocation, ventura:       "8e3d3b324ce93a041a5add3ad843c5160dc4b711b76d54295230cd68f8552923"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13f470970241a4ce5afbaf95d36d6419713f986a13198d0861cbf26ad779018c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45a6780656c96bd9a25b4f5d68f9183dc1d705d4196ab79c9e4f8fccce251a5c"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "boolean-py" do
    url "https://files.pythonhosted.org/packages/c4/cf/85379f13b76f3a69bca86b60237978af17d6aa0bc5998978c3b8cf05abb2/boolean_py-5.0.tar.gz"
    sha256 "60cbc4bad079753721d32649545505362c754e121570ada4658b852a3a318d95"
  end

  resource "cachecontrol" do
    url "https://files.pythonhosted.org/packages/b7/a4/3390ac4dfa1773f661c8780368018230e8207ec4fd3800d2c0c3adee4456/cachecontrol-0.14.2.tar.gz"
    sha256 "7d47d19f866409b98ff6025b6a0fca8e4c791fb31abbd95f622093894ce903a2"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "cyclonedx-python-lib" do
    url "https://files.pythonhosted.org/packages/66/fc/abaad5482f7b59c9a0a9d8f354ce4ce23346d582a0d85730b559562bbeb4/cyclonedx_python_lib-9.1.0.tar.gz"
    sha256 "86935f2c88a7b47a529b93c724dbd3e903bc573f6f8bd977628a7ca1b5dadea1"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/10/c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9a/filelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "license-expression" do
    url "https://files.pythonhosted.org/packages/74/6f/8709031ea6e0573e6075d24ea34507b0eb32f83f10e1420f2e34606bf0da/license_expression-30.4.1.tar.gz"
    sha256 "9f02105f9e0fcecba6a85dfbbed7d94ea1c3a70cf23ddbfb5adf3438a6f6fce0"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/cb/d0/7555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4f/msgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/68/7d/0bd319dc94c7956b4d864e87d3dc03739f125ce174671e3128edd566a63e/packageurl_python-0.16.0.tar.gz"
    sha256 "69e3bf8a3932fe9c2400f56aaeb9f86911ecee2f9398dbe1b58ec34340be365d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pip-api" do
    url "https://files.pythonhosted.org/packages/b9/f1/ee85f8c7e82bccf90a3c7aad22863cc6e20057860a1361083cd2adacb92e/pip_api-0.0.34.tar.gz"
    sha256 "9b75e958f14c5a2614bae415f2adf7eeb54d50a2cfbe7e24fd4826471bac3625"
  end

  resource "pip-requirements-parser" do
    url "https://files.pythonhosted.org/packages/5e/2a/63b574101850e7f7b306ddbdb02cb294380d37948140eecd468fae392b54/pip-requirements-parser-32.0.1.tar.gz"
    sha256 "b4fa3a7a0be38243123cf9d1f3518da10c51bdb165a2b2985566247f9155a7d3"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b6/2d/7d512a3913d60623e7eb945c6d1b4f0bddf1d0b7ada5225274c87e5b53d1/platformdirs-4.3.7.tar.gz"
    sha256 "eb437d586b6a0986388f0d6f74aa0cde27b48d0e3d66843640bfb6bdcdb6e351"
  end

  resource "py-serializable" do
    url "https://files.pythonhosted.org/packages/f0/75/813967eae0542776314c6def33feac687642a193b9d5591c20684b2eafd8/py_serializable-2.0.0.tar.gz"
    sha256 "e9e6491dd7d29c31daf1050232b57f9657f9e8a43b867cca1ff204752cf420a5"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/bb/22/f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60f/pyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a1/53/830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8/rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"requirements.txt"
    test_file.write <<~REQUIREMENTS
      six==1.16.0
    REQUIREMENTS
    output = shell_output("#{bin}/pip-audit --requirement #{test_file} --no-deps --progress-spinner=off 2>&1")
    assert_match "No known vulnerabilities found", output
  end
end
