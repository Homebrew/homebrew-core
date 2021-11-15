class Nox < Formula
  include Language::Python::Virtualenv

  desc "Flexible test automation for Python"
  homepage "https://nox.thea.codes/"
  url "https://files.pythonhosted.org/packages/11/46/c6f4944a1ffdec93a96f942bddd9b8308c2f90fe37a6512bbd2d420283ac/nox-2021.10.1.tar.gz"
  sha256 "0a1c735d5e90fa234046b58a5ad61d08bc13ae77ab213da9b58d5cc2d25023ae"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67621154abe26b6b170a901820e05f05d0beb01d70d493fa7a96dda7fe1c5d69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a37b99ed15b342899b853ff502449bbb13d4b187a852251771b3acacaa50771e"
    sha256 cellar: :any_skip_relocation, monterey:       "a199c50c73de7b2d6cffda034617e8b8fd1d9b1d5455ffc5ab056c1db80530e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9d1c726812f71425e03e25121ffa231a89b976e0092ef16e4b766c91ba81623"
    sha256 cellar: :any_skip_relocation, catalina:       "49b715ed9d987ffce96e2c407b35350677f41c3ba32ef1a5ca19879273e70763"
    sha256 cellar: :any_skip_relocation, mojave:         "978481e1a267922b2671d3bed4c0b12f26de52b07f339d568e3179ee66334fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50100e24f771050fc407cb31d69cd8fadaad9a6fb8b7bbbf0456b22f50cfec73"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6a/b4/3b1d48b61be122c95f4a770b2f42fc2552857616feba4d51f34611bd1352/argcomplete-1.12.3.tar.gz"
    sha256 "2c7dbffd8c045ea534921e63b0be6fe65e88599990d8dc408ac8c542b72a5445"
  end

  resource "backports.entry-points-selectable" do
    url "https://files.pythonhosted.org/packages/e4/7e/249120b1ba54c70cf988a8eb8069af1a31fd29d42e3e05b9236a34533533/backports.entry_points_selectable-1.1.0.tar.gz"
    sha256 "988468260ec1c196dab6ae1149260e2f5472c9110334e5d51adcb77867361f6a"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/d6/4a/840f6cb7e922a717c765a3cdc6988aff22a6ef211d88c8d16701dfbd664f/colorlog-6.4.1.tar.gz"
    sha256 "af99440154a01f27c09256760ea3477982bf782721feaa345904e806879df4d8"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/56/ed/9c876a62efda9901863e2cc8825a13a7fcbda75b4b498103a4286ab1653b/distlib-0.3.3.zip"
    sha256 "d982d0751ff6eaaab5e2ec8e691d949ee80eddf01a62eaa96ddb11531fe16b05"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/18/3d/82769bc929807a11e455265a402c9012a31dacd72a1b85795f337bb0c3fe/filelock-3.2.0.tar.gz"
    sha256 "85ecb30757aa19d06bfcdad29cc332b9a3e4851bf59976aea1e8dadcbd9ef883"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/86/aef78bab3afd461faecf9955a6501c4999933a48394e90f03cd512aad844/packaging-21.0.tar.gz"
    sha256 "7dc96269f53a4ccec5c0670940a4281106dd0bb343f47b7471f779df49c2fbe7"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/4b/96/d70b9462671fbeaacba4639ff866fb4e9e558580853fc5d6e698d0371ad4/platformdirs-2.4.0.tar.gz"
    sha256 "367a5e80b3d04d2428ffa76d33f124cf11e8fff2acdaa9b43d545f5c7d661ef2"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/0d/8c/50e9f3999419bb7d9639c37e83fa9cdcf0f601a9d407162d6c37ad60be71/py-1.10.0.tar.gz"
    sha256 "21b81bda15b66ef5e1a777a21c4dcd9c20ad3efd0b3f817e7a809035269e1bd3"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/dd/40/9bc1b32521f78c293c1f8ca423c725737dfa9d09640dbeec61cebca7c5f2/virtualenv-20.8.1.tar.gz"
    sha256 "bcc17f0b3a29670dd777d6f0755a4c04f28815395bca279cdcb213b97199a6b8"
  end

  def install
    virtualenv_install_with_resources
    (bin/"tox-to-nox").unlink
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"noxfile.py").write <<~EOS
      import nox

      @nox.session
      def tests(session):
          session.install("pytest")
          session.run("pytest")
    EOS
    (testpath/"test_trivial.py").write <<~EOS
      def test_trivial():
          assert True
    EOS
    assert_match "usage", shell_output("#{bin}/nox --help")
    assert_match "1 passed", shell_output("#{bin}/nox")
  end
end
