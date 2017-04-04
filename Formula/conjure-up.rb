class ConjureUp < Formula
  include Language::Python::Virtualenv

  desc "Big software deployments so easy it's almost magical."
  homepage "http://conjure-up.io"
  url "https://github.com/conjure-up/conjure-up/archive/2.1.tar.gz"
  sha256 "933f94c21b999fd24b4c304ba27c59bde9c83f478f5ee6a45cb8f265aaac2658"

  head "https://github.com/conjure-up/conjure-up.git", :branch => "master"

  bottle do
    sha256 "44333b2f820368ba0b2a444c67168fba999152ba681c55a8535505462575376e" => :sierra
    sha256 "64ae5c6a33c1e8a4b2c8bd0100d4ad5c91c77b172c885f07e056e5cf5e409b7f" => :el_capitan
    sha256 "1e406f6345d405a67eca6f9d03a1566a65e5b510892b45d5a9e0aaf750d99b67" => :yosemite
  end

  devel do
    url "https://github.com/conjure-up/conjure-up/archive/2.2.0-beta1.tar.gz"
    version "2.2-beta1"
    sha256 "1db2696b12e78aafc62d6987a879f8d4c37a5b058208ebe15f42a978b526268e"
  end

  depends_on :python3
  depends_on "libyaml"
  depends_on "juju"
  depends_on "juju-wait"
  depends_on "jq"
  depends_on "wget"

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
    url "https://pypi.python.org/packages/3c/3e/c4a8aca4eb5ce2e462d56a9c6bfc54f8502f07708462786b1b6caf91b7a2/progressbar2-3.16.0.tar.gz"
    sha256 "2472df1f98e458d36294e5e43439825ca1fc64dd8e44bdb4740005bd38f963ba"
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

  resource "ws4py" do
    url "https://pypi.python.org/packages/aa/60/5d135c8161a2a67d7c227d57bb599fad967d818dbcdca08daa2d60eb87b9/ws4py-0.3.4.tar.gz"
    sha256 "85d5c01bb0d031e151a32fad56094caf54e20c2ddb51cf25b5709421ff92d007"
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

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "No spells found, syncing from registry, please wait", shell_output("#{bin}/conjure-up openstack-base metal --show-env")
    File.exist? "#{testpath}/.cache/conjure-up-spells/spells-index.yaml"
  end
end
