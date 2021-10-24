class Cvise < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Super-parallel Python port of the C-Reduce"
  homepage "https://github.com/marxin/cvise"
  url "https://github.com/marxin/cvise/archive/v2.4.0.tar.gz"
  sha256 "55ae8c39bdbaddba9a2ac1173bef7995e58387bc81f4610125dd1488c8e8b1ae"
  license "NCSA"

  depends_on "cmake" => :build
  depends_on "llvm"

  uses_from_macos "flex" => :build
  uses_from_macos "unifdef"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "flake8" do
    url "https://files.pythonhosted.org/packages/e6/84/d8db922289195c435779b4ca3a3f583f263f87e67954f7b2e83c8da21f48/flake8-4.0.1.tar.gz"
    sha256 "806e034dda44114815e23c16ef92f95c91e4c71100ff52813adf7132a6ad870d"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/23/a2/97899f6bd0e873fed3a7e67ae8d3a08b21799430fb4da15cfedf10d6e2c2/iniconfig-1.1.1.tar.gz"
    sha256 "bc3af051d7d14b2ee5ef9969666def0cd1a000e121eaea580d4a313df4b37f32"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/06/18/fa675aa501e11d6d6ca0ae73a101b2f3571a565e0f7d38e062eec18a91ee/mccabe-0.6.1.tar.gz"
    sha256 "dd8d182285a0fe56bace7f45b5e7d1a6ebcbf524e8f3bd87eb0f125271b8831f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/86/aef78bab3afd461faecf9955a6501c4999933a48394e90f03cd512aad844/packaging-21.0.tar.gz"
    sha256 "7dc96269f53a4ccec5c0670940a4281106dd0bb343f47b7471f779df49c2fbe7"
  end

  resource "Pebble" do
    url "https://files.pythonhosted.org/packages/ad/a0/aa47393bf9a4c8f4c09f1736d62e9591436d8bda27d1a529d855acfd51e8/Pebble-4.6.3.tar.gz"
    sha256 "694e1105db888f3576b8f00662f90b057cf3780e6f8b7f57955a568008d0f497"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/0d/8c/50e9f3999419bb7d9639c37e83fa9cdcf0f601a9d407162d6c37ad60be71/py-1.10.0.tar.gz"
    sha256 "21b81bda15b66ef5e1a777a21c4dcd9c20ad3efd0b3f817e7a809035269e1bd3"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/08/dc/b29daf0a202b03f57c19e7295b60d1d5e1281c45a6f5f573e41830819918/pycodestyle-2.8.0.tar.gz"
    sha256 "eddd5847ef438ea1c7870ca7eb78a9d47ce0cdb4851a5523949f2601d0cbbe7f"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/15/60/c577e54518086e98470e9088278247f4af1d39cb43bcbd731e2c307acd6a/pyflakes-2.4.0.tar.gz"
    sha256 "05a85c2872edf37a4ed30b0cce2f6093e1d0581f8c19d7393122da7e25b2b24c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/69/42/aa0fa900c3a5f142098e1b013995e92c2f31e1de68042cb95fa4a022bb8a/pyparsing-3.0.0.tar.gz"
    sha256 "001cad8d467e7a9248ef9fd513f5c0d39afcbcb9a43684101853bd0ab962e479"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/4b/24/7d1f2d2537de114bdf1e6875115113ca80091520948d370c964b88070af2/pytest-6.2.5.tar.gz"
    sha256 "131b36680866a76e6781d13f101efb86cf674ebb9762eb70d3082b6f29889e89"
  end

  resource "pytest-flake8" do
    url "https://files.pythonhosted.org/packages/b2/d0/98ed7739adee0e64b53c787d2914e6061e16881bd50284aae2ae2003aa0b/pytest-flake8-1.0.7.tar.gz"
    sha256 "f0259761a903563f33d6f099914afef339c085085e643bee8343eb323b32dd6b"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DPYTHON_EXECUTABLE=#{libexec}/bin/python3"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Replace shebang with virtualenv python
    rw_info = python_shebang_rewrite_info("#{libexec}/bin/python3")
    rewrite_shebang rw_info, bin/"cvise", bin/"cvise-delta"
  end

  test do
    system "#{bin}/cvise", "--version"
  end
end
