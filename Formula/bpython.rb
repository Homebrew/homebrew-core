class Bpython < Formula
  include Language::Python::Virtualenv

  desc "Fancy interface to the Python interpreter"
  homepage "https://bpython-interpreter.org"
  url "https://files.pythonhosted.org/packages/8f/34/7bdeba9999d2dfe5c0682291966bfa7edcedf2859885fa0037b8a38d0878/bpython-0.21.tar.gz"
  sha256 "88aa9b89974f6a7726499a2608fa7ded216d84c69e78114ab2ef996a45709487"
  license "MIT"
  head "https://github.com/bpython/bpython.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "de35dcdf907c27c31b10b85c905cbea73b607a0831b96a3689776603b935b6cf" => :big_sur
    sha256 "88c6afa2a6f4623623fbbfb0c08e73fdae892ab6e5d260342b1946c7bb98613a" => :arm64_big_sur
    sha256 "9b59cf323587ed75e060f3abf996dd6a834b31bc82d9c56710ee6be15d93c365" => :catalina
    sha256 "c41f6683a528a6427c62c8323b4c1d4dcb1f1a53beaf192382cdbd1c7413ade0" => :mojave
  end

  depends_on "python@3.9"

  resource "blessings" do
    url "https://files.pythonhosted.org/packages/5c/f8/9f5e69a63a9243448350b44c87fae74588aa634979e6c0c501f26a4f6df7/blessings-1.7.tar.gz"
    sha256 "98e5854d805f50a5b58ac2333411b0482516a8210f23f43308baeb58d77c157d"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "curtsies" do
    url "https://files.pythonhosted.org/packages/ee/17/9647eb1c537734adba77bd4613a2a6563a1439444827323cfe37652f9822/curtsies-0.3.5.tar.gz"
    sha256 "a587ff3335667a32be7afed163f60a1c82c5d9c848d8297534a06fd29de20dbd"
  end

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/77/3a/7674069b8b8a40b1e25eea33c3a228b8d57c24f3e286e6de1825e0e02437/cwcwidth-0.1.1.tar.gz"
    sha256 "042cdf80d80a836935f700d8e1c34270f82a627fc07f7b5ec1e8cec486e1d755"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/92/be/878cc5314fa5aadce33e68738c1a24debe317605196bdfc2049e66bc9c30/greenlet-1.0.0.tar.gz"
    sha256 "719e169c79255816cdcf6dccd9ed2d089a72a9f6c42273aae12d55e8d35bdcf8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e1/86/8059180e8217299079d8719c6e23d674aadaba0b1939e25e0cc15dcf075b/Pygments-2.7.4.tar.gz"
    sha256 "df49d09b498e83c1a73128295860250b0b7edd4c723a32e9bc0d295c7c2ec337"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/6f/2e/2251b5ae2f003d865beef79c8fcd517e907ed6a69f58c32403cec3eba9b2/pyxdg-0.27.tar.gz"
    sha256 "80bd93aae5ed82435f20462ea0208fb198d8eec262e831ee06ce9ddb6b91c5a5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/29/e6/d1a1d78c439cad688757b70f26c50a53332167c364edb0134cadd280e234/urllib3-1.26.2.tar.gz"
    sha256 "19188f96923873c92ccb987120ec4acaa12f0461fa9ce5d3d0772bc965a39e08"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")
    venv.pip_install resources
    venv.pip_install buildpath

    # Make the Homebrew site-packages available in the interpreter environment
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", HOMEBREW_PREFIX/"lib/python#{xy}/site-packages"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    combined_pythonpath = ENV["PYTHONPATH"] + "${PYTHONPATH:+:}$PYTHONPATH"
    %w[bpdb bpython].each do |cmd|
      (bin/cmd).write_env_script libexec/"bin/#{cmd}", PYTHONPATH: combined_pythonpath
    end
  end

  test do
    require "pty"
    (testpath/"test.py").write "print(2+2)\n"
    PTY.spawn(bin/"bpython", "test.py") do |r, _w, _pid|
      assert_equal "4", r.read.chomp
    end
  end
end
