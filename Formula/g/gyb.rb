class Gyb < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "CLI for backing up and restoring Gmail messages"
  homepage "https://github.com/GAM-team/got-your-back/"
  # Check gyb.py imports for any changes. Update `pypi_packages` (if necessary)
  # and then run `brew update-python-resources gyb`.
  url "https://github.com/GAM-team/got-your-back/archive/refs/tags/v1.95.tar.gz"
  sha256 "96d8ec7c63bb33e5484f5ad6ac28c5762e9f2a2296d55955e0f48527ebcde45c"
  license "Apache-2.0"
  head "https://github.com/GAM-team/got-your-back.git", branch: "main"

  # This regex limits the length of the major version to avoid a date-based tag
  # (20250831.221201).
  livecheck do
    url :stable
    regex(/^v?(\d{,3}(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cce016a539a683c057b8629de4141347c68e17020b32bf208a51a227c62765f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79284b61261f22098a5464fd12ddf47eaf775e4249fb17ef84b9db3af0fcc63b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41a173a2d05c2dcab747540fd493bbb968d9713c73e3952c64a93fba4cf8184d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5ca4b2f0565c78f16374dfe92d6896899391d7d9a73727a06d14b5890202955"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cadd244873a95f56800351ea23dafc2d8df312b7a0741d343c0dac26a2973ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7435f2202b6595ceef4b1fd0cef794caf5daaa0331c43ce81b1950ccd363891"
  end

  depends_on "certifi"
  depends_on "python@3.14"

  pypi_packages package_name:     "",
                exclude_packages: "certifi",
                extra_packages:   %w[google-api-python-client google-auth google-auth-httplib2
                                     google-auth-oauthlib httplib2]

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/cc/7e/b975b5814bd36faf009faebe22c1072a1fa1168db34d285ef0ba071ad78c/cachetools-6.2.1.tar.gz"
    sha256 "3f391e4bd8f8bf0931169baf7456cc822705f4e2a31f840d218f445b9a854201"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/32/ea/e7b6ac3c7b557b728c2d0181010548cbbdd338e9002513420c5a354fa8df/google_api_core-2.26.0.tar.gz"
    sha256 "e6e6d78bd6cf757f4aee41dcc85b07f485fbb069d5daa3afb126defba1e91a62"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/8e/5a/6f9b49d67ea91376305fdb8bbf2877c746d756e45fd8fb7d2e32d6dad19b/google_api_python_client-2.185.0.tar.gz"
    sha256 "aa1b338e4bb0f141c2df26743f6b46b11f38705aacd775b61971cbc51da089c3"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/a8/af/5129ce5b2f9688d2fa49b463e544972a7c82b0fdb50980dafee92e121d9f/google_auth-2.41.1.tar.gz"
    sha256 "b76b7b1f9e61f0cb7e88870d14f6a94aeef248959ef6992670efee37709cbfd2"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/fb/87/e10bf24f7bcffc1421b84d6f9c3377c30ec305d082cd737ddaa6d8f77f7c/google_auth_oauthlib-1.2.2.tar.gz"
    sha256 "11046fb8d3348b296302dd939ace8af0a724042e8029c1b872d87fabc9f41684"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/39/24/33db22342cf4a2ea27c9955e6713140fedd51e8b141b5ce5260897020f1a/googleapis_common_protos-1.70.0.tar.gz"
    sha256 "0e1b44e0ea153e6594f9f394fef15193a68aaaea2d843f83e2742717ca753257"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/52/77/6653db69c1f7ecfe5e3f9726fdadc981794656fcd7d98c4209fecfea9993/httplib2-0.31.0.tar.gz"
    sha256 "ac7ab497c50975147d4f7b1ade44becc7df2f8954d42b38b3d69c515f531135c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/f4/ac/87285f15f7cce6d4a008f33f1757fb5a13611ea8914eb58c3d0d26243468/proto_plus-1.26.1.tar.gz"
    sha256 "21a515a4c4c0088a773899e23c7bbade3d18f9c66c73edd4c7ee3816bc96a012"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/19/ff/64a6c8f420818bb873713988ca5492cba3a7946be57e027ac63495157d97/protobuf-6.33.0.tar.gz"
    sha256 "140303d5c8d2037730c548f8c7b93b20bb1dc301be280c378b82b8894589c954"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f2/a5/181488fc2b9d093e3972d2a472855aae8a03f000592dbfce716a512b3359/pyparsing-3.2.5.tar.gz"
    sha256 "2df8d5b7b2802ef88e8d016a2eb9c7aeaa923529cd251ed0fe4608275d4105b6"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/da/8a/22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4/rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    # change user config location from default of executable own path
    inreplace "gyb.py", "default=getProgPath()",
                        "default='#{pkgetc}'"

    python3 = "python3.14"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    rw_info = python_shebang_rewrite_info(venv.root/"bin/python")
    rewrite_shebang rw_info, "gyb.py"
    bin.install "gyb.py" => "gyb"
    venv.site_packages.install buildpath.glob("*.py")
    pkgetc.mkpath
  end

  def caveats
    "Default config_folder: #{pkgetc}"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/gyb --version 2>&1")
    # Below throws a bad exit code but we can check it actually is failing
    # for the right reasons by asserting. --version never fails even if
    # resources are missing or outdated/too new/etc.
    assert_match "ERROR: --email is required.", shell_output(bin/"gyb", 1)
  end
end
