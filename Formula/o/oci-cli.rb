class OciCli < Formula
  include Language::Python::Virtualenv

  desc "Oracle Cloud Infrastructure CLI"
  homepage "https://docs.cloud.oracle.com/iaas/Content/API/Concepts/cliconcepts.htm"
  url "https://files.pythonhosted.org/packages/99/04/e21a01c8ee708fb251ad1cf9f019caba519bd1e09508eeb69a54e0bf337b/oci_cli-3.85.0.tar.gz"
  sha256 "5d4a31977bc54fecb17ab0f6be5f905404c1dfe261d6c66f2ac77753edc88c28"
  license any_of: ["UPL-1.0", "Apache-2.0"]
  head "https://github.com/oracle/oci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ce971f053a6176c2164f2a545d7971143cf002023256daaac05e69f9bd845d40"
    sha256 cellar: :any, arm64_sequoia: "ee17ab7667c4032c3ab5eb569629f3c180ce686f94166910a653a24b28bd0d42"
    sha256 cellar: :any, arm64_sonoma:  "51a59345a1a371149ab0d7b146d2daaf1a509723b63e8bcf5985743aa1ed7b39"
    sha256 cellar: :any, sonoma:        "99975971f8bde118f31f2e8cf22ec931ed55d96166a62142066e0268cb8586b1"
    sha256 cellar: :any, arm64_linux:   "a645660c3c87c13f8fa25b306c2b1edc0d3b24310ac8721e2d8cdf994095ec32"
    sha256 cellar: :any, x86_64_linux:  "b3bbf51f451cbbb68b08d87b2b6c40c7d0f49ee98236fcb0f97be1b235fc356e"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/b9/33/032cdc44182491aa708d06a68b62434140d8c50820a087fac7af37703357/arrow-1.4.0.tar.gz"
    sha256 "ed0cc050e98001b8779e84d461b0098c4ac597e88704a655582b21d116e526d7"
  end

  resource "circuitbreaker" do
    url "https://files.pythonhosted.org/packages/df/ac/de7a92c4ed39cba31fe5ad9203b76a25ca67c530797f6bb420fff5f65ccb/circuitbreaker-2.1.3.tar.gz"
    sha256 "1a4baee510f7bea3c91b194dcce7c07805fe96c4423ed5594b75af438531d084"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/42/e1/4cb2d3a2416bcd871ac93f12b5616f7755a6800bccae05e5a99d3673eb69/click-8.1.2.tar.gz"
    sha256 "479707fe14d9ec9a0757618b7a100a0ae4c4e236fac5b7f80ca68028141a1a72"
  end

  resource "crc32c" do
    url "https://files.pythonhosted.org/packages/e3/66/7e97aa77af7cf6afbff26e3651b564fe41932599bc2d3dce0b2f73d4829a/crc32c-2.8.tar.gz"
    sha256 "578728964e59c47c356aeeedee6220e021e124b9d3e8631d95d9a5e5f06e261c"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "oci" do
    url "https://files.pythonhosted.org/packages/96/eb/f4e9a840c2c703bf78f1ca8506514bb1195792715dcf52fbb92cab4a6cec/oci-2.177.0.tar.gz"
    sha256 "941c15283677ec5ca65d82a4bc71bae28692d73e79abbaf5eccb305a0ddb1251"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/cc/c6/25b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126ca/prompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/1a/51/27a5ad5f939d08f690a326ef9582cda7140555180db71695f6fb747d6a36/pyopenssl-26.2.0.tar.gz"
    sha256 "8c6fcecd1183a7fc897548dfe388b0cdb7f37e018200d8409cf33959dbe35387"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/ff/46/dd499ec9038423421951e4fad73051febaa13d2df82b4064f87af8b8c0c3/pytz-2026.2.tar.gz"
    sha256 "0e60b47b29f21574376f218fe21abc009894a2321ea16c6754f3cad6eb7cdd6a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/76/95/faf61eb8363f26aa7e1d762267a8d602a1b26d4f3a1e758e92cb3cb8b054/setuptools-80.10.2.tar.gz"
    sha256 "8b0e9d10c784bf7d262c4e5ec5d4ec94127ce206e8738f29a437945fbc219b70"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/f5/fc/0b73d782f5ab7feba8d007573a3773c58255f223c5940a7b7085f02153c3/terminaltables-3.1.10.tar.gz"
    sha256 "ba6eca5cb5ba02bba4c9f4f985af80c54ec3dccf94cfcd190154386255e47543"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/ba/19/1b9b0e29f30c6d35cb345486df41110984ea67ae69dddbc0e8a100999493/tzdata-2026.2.tar.gz"
    sha256 "9173fde7d80d9018e02a662e168e5a2d04f87c41ea174b139fbef642eda62d10"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/2c/ee/afaf0f85a9a18fe47a67f1e4422ed6cf1fe642f0ae0a2f81166231303c52/wcwidth-0.7.0.tar.gz"
    sha256 "90e3a7ea092341c44b99562e75d09e4d5160fe7a3974c6fb842a101a95e7eed0"
  end

  def install
    venv = virtualenv_install_with_resources without: "terminaltables"

    # Switch build-system to poetry-core to avoid rust dependency on Linux.
    # Remove when released: https://github.com/matthewdeanmartin/terminaltables/pull/1
    resource("terminaltables").stage do
      inreplace "pyproject.toml", 'requires = ["poetry>=0.12"]', 'requires = ["poetry-core>=1.0"]'
      inreplace "pyproject.toml", 'build-backend = "poetry.masonry.api"', 'build-backend = "poetry.core.masonry.api"'
      venv.pip_install Pathname.pwd
    end

    # TODO: remove `shells` argument to include `bash` completions with click 8.1.7+
    # https://github.com/pallets/click/commit/d9db70cabdc9cb10cd5584464b8adb9a24545b92
    generate_completions_from_executable(bin/"oci", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oci --version")

    assert_match "Usage: oci [OPTIONS] COMMAND [ARGS]", shell_output("#{bin}/oci --help")
    assert_match "Could not find config file", shell_output("#{bin}/oci session validate 2>&1", 1)
  end
end
