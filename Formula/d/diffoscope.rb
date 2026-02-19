class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/e1/d1/49e81bd348ca929f744a84c67eb1c4d0c33e637ba32d2834df921568361f/diffoscope-312.tar.gz"
  sha256 "aaa22b238d5b1d1804ee86b7a0526759b2984935f260a9ea8d72da7dd3c41c7f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "247b5d87cebff6b69c24403d895ae039112b1716fccf953830f79c08d693fd8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "247b5d87cebff6b69c24403d895ae039112b1716fccf953830f79c08d693fd8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "247b5d87cebff6b69c24403d895ae039112b1716fccf953830f79c08d693fd8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b3d6751ab4ecfc20a2582cc9aaa59bd0659500699be597b82c6de08d5eb6239"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f63ab123b8bc0dfae2ff24087f3909281d14bd2098208c1a3e9e091d7e57d214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f63ab123b8bc0dfae2ff24087f3909281d14bd2098208c1a3e9e091d7e57d214"
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
