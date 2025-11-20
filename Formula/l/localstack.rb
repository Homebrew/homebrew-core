class Localstack < Formula
  include Language::Python::Virtualenv

  desc "Fully functional local AWS cloud stack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/90/19/65a26e147647440a4333433307acd9ce6f58e46c5941f816f705c2d152f3/localstack-4.10.0.tar.gz"
  sha256 "b354f6114ce5852642fcfdcb8c3250eecf8416b50d555a57b9a60e0d7731f9ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6a1facc049797f2165bcec7281605e6fb8953f281ac0fac12776f0f44258c475"
    sha256 cellar: :any,                 arm64_sequoia: "1a4adebc8525c5eec47ed73cc4015af047aa43c3fec239fe7ff07dbed67756db"
    sha256 cellar: :any,                 arm64_sonoma:  "cdc528c91688f697742d13f03de610cdaf4f816f924e568a3a59eb79c8a1b1a7"
    sha256 cellar: :any,                 sonoma:        "30a74d0b35a67dc9fdc036208b94ec8896bdbbeb3c9e02d711239a11d4f02860"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa562e5875271945d8a75c2af5566192d55edd2d6b54da27458c10e12d87eb92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f26f3c32e93229b2566e1901e6a5ea1b5d113fd4c3dba66f4ac4fff468f93014"
  end

  depends_on "rust" => :build # for orjson
  depends_on "docker" => :test
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "avro" do
    url "https://files.pythonhosted.org/packages/60/00/af1eec633637e12d0945a97f05a429eed83ac45865af60cb453db4689d95/avro-1.12.1.tar.gz"
    sha256 "c5b8dd2dd4c10816f0dc127cc29cfd43b5e405cf7e6840e89460a024bf3d098d"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/cc/7e/b975b5814bd36faf009faebe22c1072a1fa1168db34d285ef0ba071ad78c/cachetools-6.2.1.tar.gz"
    sha256 "3f391e4bd8f8bf0931169baf7456cc822705f4e2a31f840d218f445b9a854201"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/7c/e7/364a09134e1062d4d5ff69b853a56cf61c223e0afcc6906b6832bcd51ea8/dill-0.3.6.tar.gz"
    sha256 "e5db55f3687856d8fbdab002ed78544e1c4559a130302693d839dfe8f93f2373"
  end

  resource "dnslib" do
    url "https://files.pythonhosted.org/packages/a2/71/269f74ef9bc8ca453af2e1768d4f4c8e7ef5f894d058d27fd1b69c754d7f/dnslib-0.9.26.tar.gz"
    sha256 "be56857534390b2fbd02935270019bacc5e6b411d156cb3921ac55a7fb51f1a8"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "fastavro" do
    url "https://files.pythonhosted.org/packages/65/8b/fa2d3287fd2267be6261d0177c6809a7fa12c5600ddb33490c8dc29e77b2/fastavro-1.12.1.tar.gz"
    sha256 "2f285be49e45bc047ab2f6bed040bb349da85db3f3c87880e4b92595ea093b2b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "localstack-core" do
    url "https://files.pythonhosted.org/packages/31/0b/0357417267182c77ac813226777a48ea3b35e6749bcf4bac5ce696dec504/localstack_core-4.10.0.tar.gz"
    sha256 "467794036c9adcf4a5c868c7e69f10e07ea4217fbc337e196032905b9c9177f5"
  end

  resource "localstack-ext" do
    url "https://files.pythonhosted.org/packages/bd/62/9fa8a7c5e340170f95c0d96dd8a2e897c97c9f8d1ae64f3cd0a8dac9cde4/localstack_ext-4.10.0.tar.gz"
    sha256 "3f6b614596d959427d7c2b7d2bca72020bcd2e289aa682ba0c4f604d97ab1bff"
  end

  resource "localstack-py-avro-schema" do
    url "https://files.pythonhosted.org/packages/4c/99/36dc63bb57a7c637a79d9bf220098fcefa8ab029c065fb4f68fceca61413/localstack_py_avro_schema-3.9.4.tar.gz"
    sha256 "83609fb30993e702df656e7deeb377aa3a11c409c569d10cdd2e3fb26af8fce5"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "memoization" do
    url "https://files.pythonhosted.org/packages/af/53/e948a943e16423a87ced16e34ea7583c300e161a4c3e85d47d77d83830bf/memoization-0.4.0.tar.gz"
    sha256 "fde5e7cd060ef45b135e0310cfec17b2029dc472ccb5bbbbb42a503d4538a135"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/c6/fe/ed708782d6709cc60eb4c2d8a361a440661f74134675c72990f2c48c785f/orjson-3.11.4.tar.gz"
    sha256 "39485f4ab4c9b30a3943cfe99e1a213c4776fb69e8abd68f66b83d5a0b0fdc6d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "plux" do
    url "https://files.pythonhosted.org/packages/14/4b/bea3ff709d4d17b1e0351058c9dbe830dcbb33a75225836056f4591dfb1d/plux-1.13.0.tar.gz"
    sha256 "0358a618883be270cf8dd6b5ae48e633a7fecd386cff6347c8560116f4688a75"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/cd/ec/7b8e6b9b1d22708138630ef34c53ab2b61032c04f16adfdbb96791c8c70c/psutil-7.1.2.tar.gz"
    sha256 "aa225cdde1335ff9684708ee8c72650f6598d5ed2114b9a7c5802030b1785018"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/e7/46/bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726/pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "pyotp" do
    url "https://files.pythonhosted.org/packages/f3/b2/1d5994ba2acde054a443bd5e2d384175449c7d2b6d1a0614dbca3a63abfc/pyotp-2.9.0.tar.gz"
    sha256 "346b6642e0dbdde3b4ff5a930b664ca82abfa116356ed48cc42c7d6590d36f63"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f0/26/19cadc79a718c5edbec86fd4919a6b6d3f681039a2f6d66d14be94e75fb9/python_dotenv-1.2.1.tar.gz"
    sha256 "42667e897e16ab0d66954af0e60a9caa94f0fd4ecf3aaf6d2d260eec1aa36ad6"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/72/d1/d3159231aec234a59dd7d601e9dd9fe96f3afff15efd33c1070019b26132/semver-3.0.4.tar.gz"
    sha256 "afc7d8c584a5ed0a11033af086e8af226a9c0b206f313e0301f8dd7b6b589602"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "typeguard" do
    url "https://files.pythonhosted.org/packages/3a/38/c61bfcf62a7b572b5e9363a802ff92559cb427ee963048e1442e3aef7490/typeguard-2.13.3.tar.gz"
    sha256 "00edaa8da3a133674796cf5ea87d9f4b4c367d77476e185e80251cc13dfbb8c4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/localstack"

    generate_completions_from_executable(bin/"localstack", shell_parameter_format: :click)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://" + (testpath/"invalid.sock")
    ENV["LOCALSTACK_API_KEY"] = "brewtest"

    assert_match version.to_s, shell_output("#{bin}/localstack --version")

    output = shell_output("#{bin}/localstack start --docker 2>&1", 1)

    assert_match "License activation failed!", output
  end
end
