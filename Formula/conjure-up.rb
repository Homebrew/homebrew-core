class ConjureUp < Formula
  include Language::Python::Virtualenv

  desc "Big software deployments so easy it's almost magical."
  homepage "http://conjure-up.io"
  url "https://github.com/conjure-up/conjure-up/archive/2.1.5.tar.gz"
  sha256 "df8278ffca2eab81bf02e6fe422e283baaee52b01e8a7b3bad1ca91ffa691af0"
  head "https://github.com/conjure-up/conjure-up.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "406feece9b1f71e9a5e176146c2c3c2019cf60ef1cf98e103a3529d56a64671e" => :sierra
    sha256 "013ca91ccb21ce08eadea1c336fc02c4553bf66fde397f06fa98577666064c63" => :el_capitan
    sha256 "569e1d339c080f4f0c3c33e4c1e2db0c4332129c9c1f9ba33a1ee24fbf9e9f78" => :yosemite
  end

  devel do
    url "https://github.com/conjure-up/conjure-up/archive/2.2.0-beta3.tar.gz"
    version "2.2-beta3"
    sha256 "21349a09ec4836d6c8cf98128183fca12d1601374352974a2a32758f49ba21d1"
  end

  depends_on :python3
  depends_on "libyaml"
  depends_on "juju"
  depends_on "juju-wait"
  depends_on "jq"
  depends_on "wget"

  resource "ubuntui" do
    url "https://pypi.python.org/packages/ba/dd/bb48f3852a80679a2fd0e7728f763d9b737c068da10b0239bff3a2e07896/ubuntui-0.1.6.tar.gz"
    sha256 "10310507867122aad5f39f5bd4c478771b07331a3df60f68a9aebb1b7cd22f58"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/51/fc/39a3fbde6864942e8bb24c93663734b74e281b984d1b8c4f95d64b0c21f6/python-dateutil-2.6.0.tar.gz"
    sha256 "62a2f8df3d66f878373fd0072eacf4ee52194ba302e00082828e0d263b0418d2"
  end

  resource "theblues" do
    url "https://pypi.python.org/packages/ab/09/21a4718cb6f06573153de35af742e4c251ca9b628c9001d06f6ed4b2cae5/theblues-0.3.8.tar.gz"
    sha256 "649f4013d3b9024f7990a7e0b42aed2196daea64a7c8501dde4f1f57ab8aa031"
  end

  resource "websockets" do
    url "https://pypi.python.org/packages/73/e9/e570b5f948514db504fed6f4eb014c826bdcaa053a6bfaa1f9f4c97c3f9a/websockets-3.3.tar.gz"
    sha256 "305ab7fdd86afd08c2723461c949e153f7b01233f95a108619a15e41b7a74c93"
  end

  resource "bundle-placement" do
    url "https://pypi.python.org/packages/84/d9/4c416af49f210f46034fbcbe3ee195c272643ae5286e963aa31ea86bff99/bundle-placement-0.0.1.tar.gz"
    sha256 "a73a4d0dff43f815d1055352d21926dbf722329613e8cfa9e630374ca4e03408"
  end

  resource "python-utils" do
    url "https://pypi.python.org/packages/46/e8/60bc82e7bb5d9e326c4691ed73e02a2a0e3ce6bb7adefd8cb2d9d8456b3a/python-utils-2.0.1.tar.gz"
    sha256 "985f44edf24918d87531c339f8b126ce2d303cbbc9a4c7fc4dc81ac0726079ff"
  end

  resource "oauthlib" do
    url "https://pypi.python.org/packages/fa/2e/25f25e6c69d97cf921f0a8f7d520e0ef336dd3deca0142c0b634b0236a90/oauthlib-2.0.2.tar.gz"
    sha256 "b3b9b47f2a263fe249b5b48c4e25a5bce882ff20a0ac34d553ce43cff55b53ac"
  end

  resource "prettytable" do
    url "https://pypi.python.org/packages/e0/a1/36203205f77ccf98f3c6cf17cf068c972e6458d7e58509ca66da949ca347/prettytable-0.7.2.tar.gz"
    sha256 "2d5460dc9db74a32bcc8f9f67de68b2c4f4d2f01fa3bd518764c69156d9cacd9"
  end

  resource "progressbar2" do
    url "https://pypi.python.org/packages/8a/66/e0c1ace7ca3ee91a3e0c9e4a9ac9cb8e78679265e2a201286063d478e471/progressbar2-3.16.1.tar.gz"
    sha256 "886142e7753bb5ec02b1af36d3cf936e37ea382b46e988456e0b3f1afd2821f3"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/16/09/37b69de7c924d318e51ece1c4ceb679bf93be9d05973bb30c35babd596e2/requests-2.13.0.tar.gz"
    sha256 "5722cd09762faa01276230270ff16af7acf7c5c45d623868d9ba116f15791ce8"
  end

  resource "six" do
    url "https://pypi.python.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "termcolor" do
    url "https://pypi.python.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "urwid" do
    url "https://pypi.python.org/packages/85/5d/9317d75b7488c335b86bd9559ca03a2a023ed3413d0e8bfe18bea76f24be/urwid-1.3.1.tar.gz"
    sha256 "cfcec03e36de25a1073e2e35c2c7b0cc6969b85745715c3a025a31d9786896a1"
  end

  resource "pyyaml" do
    url "https://pypi.python.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/71/59/d7423bd5e7ddaf3a1ce299ab4490e9044e8dfd195420fc83a24de9e60726/Jinja2-2.9.5.tar.gz"
    sha256 "702a24d992f856fa8d5a7a36db6128198d0c21e1da34448ca236c42e92384825"
  end

  resource "requests-oauthlib" do
    url "https://pypi.python.org/packages/80/14/ad120c720f86c547ba8988010d5186102030591f71f7099f23921ca47fe5/requests-oauthlib-0.8.0.tar.gz"
    sha256 "883ac416757eada6d3d07054ec7092ac21c7f35cb1d2cf82faf205637081f468"
  end

  resource "juju" do
    url "https://pypi.python.org/packages/8e/e1/cd79f646672a8e08ef9680d60872349e609d4ac3c5eeddd2aa26deddc27e/juju-0.4.1.tar.gz"
    sha256 "f8d2afbee413b1de2041286ac36ab85321fb3ade0c8ff805c25792b85d936913"
  end


  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "No spells found, syncing from registry, please wait", shell_output("#{bin}/conjure-up openstack-base metal --show-env")
    File.exist? "#{testpath}/.cache/conjure-up-spells/spells-index.yaml"
  end
end
