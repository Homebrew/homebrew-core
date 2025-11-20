class PipAudit < Formula
  include Language::Python::Virtualenv

  desc "Audits Python environments and dependency trees for known vulnerabilities"
  homepage "https://pypi.org/project/pip-audit/"
  url "https://files.pythonhosted.org/packages/cc/7f/28fad19a9806f796f13192ab6974c07c4a04d9cbb8e30dd895c3c11ce7ee/pip_audit-2.9.0.tar.gz"
  sha256 "0b998410b58339d7a231e5aa004326a294e4c7c6295289cdc9d5e1ef07b1f44d"
  license "Apache-2.0"
  revision 2
  version_scheme 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "017e8e28f5b008268a3758cd3a4f298bd3ff6989d27cc8cf2bec06b6a6ab3b28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5da23007467c4c8c6b6f10e4caf0070e922a53f29065ac69b4bc64657796fef8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2be5f69a14ce581fe424f22df5940cc07c815a577a3e250e70c3c1b8712b93a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b93880459ced676a57b313c60acbf6513cb2261d402c09d627c4f22ceafe8b48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8037699fecf2b10d29613b26915465e2612f6956019f78433be0e28cd8a36793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5881e06137a7145b196061ba8cf62ef86c571d8f8a211b749815e1431049719"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "boolean-py" do
    url "https://files.pythonhosted.org/packages/c4/cf/85379f13b76f3a69bca86b60237978af17d6aa0bc5998978c3b8cf05abb2/boolean_py-5.0.tar.gz"
    sha256 "60cbc4bad079753721d32649545505362c754e121570ada4658b852a3a318d95"
  end

  resource "cachecontrol" do
    url "https://files.pythonhosted.org/packages/58/3a/0cbeb04ea57d2493f3ec5a069a117ab467f85e4a10017c6d854ddcbff104/cachecontrol-0.14.3.tar.gz"
    sha256 "73e7efec4b06b20d9267b441c1f733664f989fb8688391b670ca812d70795d11"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
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
    url "https://files.pythonhosted.org/packages/58/46/0028a82567109b5ef6e4d2a1f04a583fb513e6cf9527fcdd09afd817deeb/filelock-3.20.0.tar.gz"
    sha256 "711e943b4ec6be42e1d4e6690b48dc175c822967466bb31c0c293f34334c13f4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "license-expression" do
    url "https://files.pythonhosted.org/packages/40/71/d89bb0e71b1415453980fd32315f2a037aad9f7f70f695c7cec7035feb13/license_expression-30.4.4.tar.gz"
    sha256 "73448f0aacd8d0808895bdc4b2c8e01a8d67646e4188f887375398c761f340fd"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/4d/f2/bfb55a6236ed8725a96b0aa3acbd0ec17588e6a2c3b62a93eb513ed8783f/msgpack-1.1.2.tar.gz"
    sha256 "3b60763c1373dd60f398488069bcdc703cd08a711477b5d480eecc9f9626f47e"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/3a/f0/de0ac00a4484c0d87b71e3d9985518278d89797fa725e90abd3453bccb42/packageurl_python-0.17.5.tar.gz"
    sha256 "a7be3f3ba70d705f738ace9bf6124f31920245a49fa69d4b416da7037dd2de61"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
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
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "py-serializable" do
    url "https://files.pythonhosted.org/packages/73/21/d250cfca8ff30c2e5a7447bc13861541126ce9bd4426cd5d0c9f08b5547d/py_serializable-2.1.0.tar.gz"
    sha256 "9d5db56154a867a9b897c0163b33a793c804c80cee984116d02d49e4578fc103"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f2/a5/181488fc2b9d093e3972d2a472855aae8a03f000592dbfce716a512b3359/pyparsing-3.2.5.tar.gz"
    sha256 "2df8d5b7b2802ef88e8d016a2eb9c7aeaa923529cd251ed0fe4608275d4105b6"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
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
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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
