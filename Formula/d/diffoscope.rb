class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/09/4b/f68803a49ba1abdf6b1d7b135a059da0630178da369a159395e745556165/diffoscope-314.tar.gz"
  sha256 "b347d6ebcadd913a5839555b89ea1026422a1cdf7b8b3be21bb2f112133c3ff8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e17216ce9b3c0730b726d2698e7e7b0970c6461a29ceda4ff3b381b7b42f972"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e17216ce9b3c0730b726d2698e7e7b0970c6461a29ceda4ff3b381b7b42f972"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e17216ce9b3c0730b726d2698e7e7b0970c6461a29ceda4ff3b381b7b42f972"
    sha256 cellar: :any_skip_relocation, sonoma:        "d066ca12f84ef12dd107cce622b9554001b30001725f148c6c9db0f866305288"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b56eb4838b7811b44ed5a6529af5af9f36f96258da8d5923381f384ccdd2b2af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b56eb4838b7811b44ed5a6529af5af9f36f96258da8d5923381f384ccdd2b2af"
  end

  depends_on "libarchive"
  depends_on "libmagic" => :no_linkage
  depends_on "python@3.14"

  # pypi_packages package_name: "diffoscope[cmdline]"
  pypi_packages extra_packages: %w[argcomplete progressbar]

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/38/61/0b9ae6399dd4a58d8c1b1dc5a27d6f2808023d0b5dd3104bb99f45a33ff6/argcomplete-3.6.3.tar.gz"
    sha256 "62e8ed4fd6a45864acc8235409461b72c9a28ee785a2011cc5eb78318786c89c"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/26/23/e72434d5457c24113e0c22605cbf7dd806a2561294a335047f5aa8ddc1ca/libarchive_c-5.3.tar.gz"
    sha256 "5ddb42f1a245c927e7686545da77159859d5d4c6d00163c59daff4df314dae82"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  def install
    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install libexec/"bin/diffoscope"
    libarchive = Formula["libarchive"].opt_lib/shared_library("libarchive")
    bin.env_script_all_files(libexec/"bin", LIBARCHIVE: libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system bin/"diffoscope", "--progress", "test1", "test2"
  end
end
