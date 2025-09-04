class OciCli < Formula
  include Language::Python::Virtualenv

  desc "Oracle Cloud Infrastructure CLI"
  homepage "https://docs.cloud.oracle.com/iaas/Content/API/Concepts/cliconcepts.htm"
  url "https://files.pythonhosted.org/packages/65/43/874a0fe4b6c2424ff03c422e26507bef4372807310e3d3658078f0f27875/oci_cli-3.65.1.tar.gz"
  sha256 "31683ae792cd04dca9a3cd0beccc8a9a6fdbd0d73787513ae1f8225f5323661f"
  license any_of: ["UPL-1.0", "Apache-2.0"]
  head "https://github.com/oracle/oci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb18719adb96419d399d51ab514f295cbf0d321307d9fd1f8b0c9600d1f6afb0"
    sha256 cellar: :any,                 arm64_sonoma:  "0c08d97d2900c8e1adc084e20be92a442b389d1a2e6e67b0ef69e430f01e0e40"
    sha256 cellar: :any,                 arm64_ventura: "9b8f3faf79effa07d032a00b435855e6ca6d5175aa82b2361b99e8faaa93103f"
    sha256 cellar: :any,                 sonoma:        "d94e5ee3488b1933155abeaf82ac5f520f388c97e4902ce273e1bb94b3ce4b9b"
    sha256 cellar: :any,                 ventura:       "8077631f3306ecf6d7b71c603ca8ebfcc6715ed3d8aaa538b3fdb92e24eb2ca4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0d76ea2795e13d3cdd0fadc88584696b3c20771878a125b6d3187b39a575dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "634256d4865476b619607b6ec85182d912a694d59020e2e9f45824766dd0d1ba"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "circuitbreaker" do
    url "https://files.pythonhosted.org/packages/df/ac/de7a92c4ed39cba31fe5ad9203b76a25ca67c530797f6bb420fff5f65ccb/circuitbreaker-2.1.3.tar.gz"
    sha256 "1a4baee510f7bea3c91b194dcce7c07805fe96c4423ed5594b75af438531d084"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/dd/cf/706c1ad49ab26abed0b77a2f867984c1341ed7387b8030a6aa914e2942a0/click-8.0.4.tar.gz"
    sha256 "8458d7b1287c5fb128c90e23381cf99dcde74beaf6c7ff6384ce84d6fe090adb"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "oci" do
    url "https://files.pythonhosted.org/packages/bd/47/00e93af37d4937c24a99a3df00682c1c0b18731a4125e3152358e0ec4adc/oci-2.159.1.tar.gz"
    sha256 "e033413fa6fdc2353fecba55e9b6ca54df2b4976ae6c294f4ac94df2b0d44ffc"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/cc/c6/25b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126ca/prompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/c1/d4/1067b82c4fc674d6f6e9e8d26b3dff978da46d351ca3bac171544693e085/pyopenssl-24.3.0.tar.gz"
    sha256 "49f7a019577d834746bc55c5fce6ecbcec0f2b4ec5ce1cf43a9a173b8138bb36"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/f5/fc/0b73d782f5ab7feba8d007573a3773c58255f223c5940a7b7085f02153c3/terminaltables-3.1.10.tar.gz"
    sha256 "ba6eca5cb5ba02bba4c9f4f985af80c54ec3dccf94cfcd190154386255e47543"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/0c/0a/775f8551665992204c756be326f3575abba58c4a3a52eef9909ef4536428/types_python_dateutil-2.9.0.20250822.tar.gz"
    sha256 "84c92c34bd8e68b117bff742bc00b692a1e8531262d4507b33afcc9f7716cd53"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    venv = virtualenv_install_with_resources without: "terminaltables"

    # Switch build-system to poetry-core to avoid rust dependency on Linux.
    # Remove when released: https://github.com/matthewdeanmartin/terminaltables/pull/1
    resource("terminaltables").stage do
      inreplace "pyproject.toml", 'requires = ["poetry>=0.12"]', 'requires = ["poetry-core>=1.0"]'
      inreplace "pyproject.toml", 'build-backend = "poetry.masonry.api"', 'build-backend = "poetry.core.masonry.api"'
      venv.pip_install_and_link Pathname.pwd
    end

    # TODO: remove `shells` argument to include `bash` completions with click 8.1.7+
    # https://github.com/pallets/click/commit/d9db70cabdc9cb10cd5584464b8adb9a24545b92
    generate_completions_from_executable(bin/"oci", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    version_out = shell_output("#{bin}/oci --version")
    assert_match version.to_s, version_out

    assert_match "Usage: oci [OPTIONS] COMMAND [ARGS]", shell_output("#{bin}/oci --help")
    assert_match "Could not find config file", shell_output("#{bin}/oci session validate 2>&1", 1)
  end
end
