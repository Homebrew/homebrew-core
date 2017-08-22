class ConjureUp < Formula
  include Language::Python::Virtualenv

  desc "Big software deployments so easy it's almost magical."
  homepage "https://conjure-up.io/"
  url "https://github.com/conjure-up/conjure-up/archive/2.2.2.tar.gz"
  sha256 "a5064f4f86fc302acb33846c78a27a113f161235b5636aded5c790216eb21ab1"
  revision 1

  bottle do
    cellar :any
    sha256 "df1850b1798b93f6e504a7bbfded96cd6c82f4f82e0e3e127a03a0dfbef3c6ea" => :sierra
    sha256 "ec4bf98decf1d8050642e950df8d7a1ff36fa29ac4784b77d2b2e327f5241b54" => :el_capitan
    sha256 "00ba6d9a2c3771ed227506322041c41a463b8becd53cb132e95b1b769b15c2d1" => :yosemite
  end

  depends_on :python3
  depends_on "libyaml"
  depends_on "juju"
  depends_on "jq"
  depends_on "wget"
  depends_on "redis"

  # list generated from the 'requirements.txt' file in the repository root
  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/28/51/913ed4312b63b0a1b6cad5a761b2c163eb20e353c7a3f19f08e04e8675e5/aiofiles-0.3.1.tar.gz"
    sha256 "6c4936cea65175277183553dbc27d08b286a24ae5bd86f44fbe485dfcf77a14a"
  end

  resource "bundle-placement" do
    url "https://files.pythonhosted.org/packages/84/d9/4c416af49f210f46034fbcbe3ee195c272643ae5286e963aa31ea86bff99/bundle-placement-0.0.1.tar.gz"
    sha256 "a73a4d0dff43f815d1055352d21926dbf722329613e8cfa9e630374ca4e03408"
  end

  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/6e/db/41233498c210b03ab8b072c8ee49b1cd63b3b0c76f8ea0a0e5d02df06898/contextlib2-0.5.5.tar.gz"
    sha256 "509f9419ee91cdd00ba34443217d5ca51f5a364a404e1dce9e8979cea969ca48"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  resource "env" do
    url "https://github.com/battlemidget/env/archive/1.0.0.tar.gz"
    sha256 "a26b5c973df792ecfc1fc6b18cf696ccaf4c02c918b2878e81c6d495debaa340"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/90/61/f820ff0076a2599dd39406dcb858ecb239438c02ce706c8e91131ab9c7f1/Jinja2-2.9.6.tar.gz"
    sha256 "ddaa01a212cd6d641401cb01b605f4a4d9f37bfc93043d7f760ec70fb99ff9ff"
  end

  resource "juju" do
    url "https://files.pythonhosted.org/packages/f5/dc/ea4f4bff279515eda8567995109ae3ca6c5e92dc9debfc43e2c0fcb3fa51/juju-0.5.3.tar.gz"
    sha256 "2454958564c99030a8072d7315a6ceb72700e4f57fbba6d21b59f52c86b52e93"
  end

  resource "juju-wait" do
    url "https://files.pythonhosted.org/packages/71/2e/28fb91fac43f4bb87d982c6ea50525e0e38bd92c458f667ab963e43ea17f/juju-wait-2.5.1.tar.gz"
    sha256 "acb1a9b0710d486ba6f00f1d935cf9253acffa7ac1cf945be91768abd00f9950"
  end

  resource "jujubundlelib" do
    url "https://files.pythonhosted.org/packages/4c/22/c3162cac2fd3cd89097bff7533a3483f1dd8abf3abb15641ecbc7c471e98/jujubundlelib-0.5.4.tar.gz"
    sha256 "b60242623c587128f83d5426aa29dc4cf41e36c194b0d0f8d50f3111d75e18b8"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz"
    sha256 "a6be69091dac236ea9c6bc7d012beab42010fa914c459791d627dad4910eb665"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/fa/2e/25f25e6c69d97cf921f0a8f7d520e0ef336dd3deca0142c0b634b0236a90/oauthlib-2.0.2.tar.gz"
    sha256 "b3b9b47f2a263fe249b5b48c4e25a5bce882ff20a0ac34d553ce43cff55b53ac"
  end

  resource "PrettyTable" do
    url "https://files.pythonhosted.org/packages/ef/30/4b0746848746ed5941f052479e7c23d2b56d174b82f4fd34a25e389831f5/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "progressbar2" do
    url "https://files.pythonhosted.org/packages/ab/d1/44d8235bac6fca2480f256a47630aa759638f3d6ad4d3ebe8ec0ae38409d/progressbar2-3.20.0.tar.gz"
    sha256 "a16d34da27bfa9800605f1de3342138e102797a4b8198864c8822e94caa0e5f7"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/57/93/47a2e3befaf194ccc3d05ffbcba2cdcdd22a231100ef7e4cf63f085c900b/psutil-5.2.2.tar.gz"
    sha256 "44746540c0fab5b95401520d29eb9ffe84b3b4a235bd1d1971cbe36e1f38dd13"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
  end

  resource "python-utils" do
    url "https://files.pythonhosted.org/packages/19/f2/2c4c8c2a92325d0c70ef21647583179058ae64d07429e30ab2476624e40b/python-utils-2.2.0.tar.gz"
    sha256 "d9b8ab1f2a7c8f26ed16a47505f589a5d51c0d1e55869ab40c20e1c4b42af2c0"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "raven" do
    url "https://files.pythonhosted.org/packages/ee/82/9a85650c174920f5bd260b8138a1db7190156e55193b0a1d03d2fa7a2811/raven-6.1.0.tar.gz"
    sha256 "02cabffb173b99d860a95d4908e8b1864aad1b8452146e13fd7e212aa576a884"
  end

  resource "redis" do
    url "https://files.pythonhosted.org/packages/68/44/5efe9e98ad83ef5b742ce62a15bea609ed5a0d1caf35b79257ddb324031a/redis-2.10.5.tar.gz"
    sha256 "5dfbae6acfc54edf0a7a415b99e0b21c0a3c27a7f787b292eea727b1facc5533"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/72/46/4abc3f5aaf7bf16a52206bb0c68677a26c216c1e6625c78c5aef695b5359/requests-2.14.2.tar.gz"
    sha256 "a274abba399a23e8713ffd2b5706535ae280ebe2b8069ee6a941cb089440d153"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/80/14/ad120c720f86c547ba8988010d5186102030591f71f7099f23921ca47fe5/requests-oauthlib-0.8.0.tar.gz"
    sha256 "883ac416757eada6d3d07054ec7092ac21c7f35cb1d2cf82faf205637081f468"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/d8/97/39aa189a8392522cc24f14f392955cbeac48e2818d776241c37eb6d0eb3c/sh-1.12.13.tar.gz"
    sha256 "979928ca113cade663bb1a0ff710e3eb9147596cf28a7ee4c04f9d85804f7b9f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "theblues" do
    url "https://files.pythonhosted.org/packages/ab/09/21a4718cb6f06573153de35af742e4c251ca9b628c9001d06f6ed4b2cae5/theblues-0.3.8.tar.gz"
    sha256 "649f4013d3b9024f7990a7e0b42aed2196daea64a7c8501dde4f1f57ab8aa031"
  end

  resource "ubuntui" do
    url "https://files.pythonhosted.org/packages/ba/dd/bb48f3852a80679a2fd0e7728f763d9b737c068da10b0239bff3a2e07896/ubuntui-0.1.6.tar.gz"
    sha256 "10310507867122aad5f39f5bd4c478771b07331a3df60f68a9aebb1b7cd22f58"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/85/5d/9317d75b7488c335b86bd9559ca03a2a023ed3413d0e8bfe18bea76f24be/urwid-1.3.1.tar.gz"
    sha256 "cfcec03e36de25a1073e2e35c2c7b0cc6969b85745715c3a025a31d9786896a1"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/4a/e8/acf36f117deeb18c0b6679624fa11b57b0876044f0ce3f34024c3a7b2d95/websockets-3.4.tar.gz"
    sha256 "43e5b9f51dd0000a4c6f646e2ade0c886bd14a784ffac08b9e079bd17a63bcc5"
  end

  resource "ws4py" do
    url "https://files.pythonhosted.org/packages/aa/60/5d135c8161a2a67d7c227d57bb599fad967d818dbcdca08daa2d60eb87b9/ws4py-0.3.4.tar.gz"
    sha256 "85d5c01bb0d031e151a32fad56094caf54e20c2ddb51cf25b5709421ff92d007"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "No spells found, syncing from registry, please wait", shell_output("#{bin}/conjure-up openstack-base metal --show-env")
    File.exist? "#{testpath}/.cache/conjure-up-spells/spells-index.yaml"
  end
end
