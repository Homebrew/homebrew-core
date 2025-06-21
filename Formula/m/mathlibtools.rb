class Mathlibtools < Formula
  include Language::Python::Virtualenv

  desc "Lean prover mathlib supporting tools"
  homepage "https://pypi.org/project/mathlibtools"
  url "https://files.pythonhosted.org/packages/ae/6a/815d7f65dc853973b13be082fefe797074e633407ef1262a62bc0be84203/mathlibtools-1.3.2.tar.gz"
  sha256 "9a49f4cb7355fda72792a5738bcc5df927b1e102efc719adfbe16db199a0ac6b"
  license "Apache-2.0"
  revision 6

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "5c30b6bd959cec65f56d140dff795e4f6d139b2c0b9bb35e4d964378d810b729"
    sha256 cellar: :any,                 arm64_ventura:  "e7b4098b3b86e02c75fe7b9eb1d3e1233d8d941aba977e703d2a27a1e0d7c3d2"
    sha256 cellar: :any,                 arm64_monterey: "3ca76a75c8f500659d6717edbf8920b4a98a3232b4571852c1024cde7b7cd5f5"
    sha256 cellar: :any,                 sonoma:         "524e34d53bb6d589d02b9dc8fdb364786593a3731b07eaa139d2c4fdf0381c86"
    sha256 cellar: :any,                 ventura:        "6fb10a6aca23e710cf3bdab9ae2d72dd13ff614910d14a1cd9edebeb402b4e66"
    sha256 cellar: :any,                 monterey:       "7b62c45d6c24e66b8659f246fec6f92bde2d75785d2370deaccb047d95dbfa95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "749aa46ceb3aaf5e592562d7f952384543f65702848507e613b07684ce75d12d"
  end

  disable! date: "2024-09-09", because: :repo_archived

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/87/c6/53da25344e3e3a9c01095a89f16dbcda021c609ddb42dd6d7c0528236fb2/atomicwrites-1.4.1.tar.gz"
    sha256 "81b2c9071a49367a7f770170e5eec8cb66567cfbbc8c73d20ce5ca4a8d71cf11"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/98/97/06afe62762c9a8a86af0cfb7bfdab22a43ad17138b07af5b1a58442690a2/deprecated-1.2.18.tar.gz"
    sha256 "422b6f6d859da6f2ef57857761bfb392480502a64c3028ca9bbe86085d72115d"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/c0/89/37df0b71473153574a5cdef8f242de422a0f5d26d7a9e231e6f169b4ad14/gitpython-3.1.44.tar.gz"
    sha256 "c87e30b26253bf5418b01b0660f818967f3c503193838337fe5e573331249269"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/6c/4f/ccdb8ad3a38e583f214547fd2f7ff1fc160c43a75af88e6aec213404b96a/networkx-3.5.tar.gz"
    sha256 "d4c6f9cf81f52d69230866796b82afbccdec3db7ae4fbd1b65ea750feed50037"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/50/35/b17cb89ff865484c6a20ef46bf9d95a5f07328292578de0b295f4a6beec2/pydot-4.0.1.tar.gz"
    sha256 "c2148f681c4a33e08bf0e26a9e5f8e4099a82e0e2a068098f32ce86577364ad5"
  end

  resource "pygithub" do
    url "https://files.pythonhosted.org/packages/c0/88/e08ab18dc74b2916f48703ed1a797d57cb64eca0e23b0a9254e13cfe3911/pygithub-2.6.1.tar.gz"
    sha256 "b5c035392991cca63959e9453286b41b54d83bf2de2daa7d7ff7e4312cebf3bf"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/e7/46/bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726/pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/bb/22/f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60f/pyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/44/cd/a040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3b/smmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/d1/bc/51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5/typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/c3/fc/e91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcef/wrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "Could not find a leanpkg.toml\n", shell_output("#{bin}/leanproject build 2>&1", 255)
  end
end
