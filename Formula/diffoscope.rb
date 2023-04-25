class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/31/5a/58411c770d34840f51c550906c6b6d786eccbd610b098c129397becc2910/diffoscope-241.tar.gz"
  sha256 "747d3e8ea94ad1c21413355699f634bc010f4c65f9ed6491da0bf1a60ad00fdf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c22a8d96de336c83062005c83110caf1ab85f59f306e401bbf205d0d438828c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3345e2ab59baa09a25672d5f8a7a6c925d3d28fef71536b669d95a5bfdce0633"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f02934abf3704caf4890080d82805a451cdbe8eb94c2f7f0bfd11e9e1843dd88"
    sha256 cellar: :any_skip_relocation, ventura:        "a16ef5f8d238925551a02303780104760b14efdafc2a68dbbe3e6b92dae237b2"
    sha256 cellar: :any_skip_relocation, monterey:       "e47e06515f1b6772107f2566cbe14967f8d3c5a0a869ec61bcf7c791b929b502"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b84e7edccad013997847f97e4964c9e45b2af1ec9b1d7be264dbfd8da9facbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08765032c86c794ad90ecdf6c044679509c74076f1b67e7c828c76a9557b36f0"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.11"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/9d/50/e5b3e9824a387920c4b92870359c9f7dbf21a6cd6d3dff5bf4fd3b50237a/argcomplete-3.0.5.tar.gz"
    sha256 "fe3ce77125f434a0dd1bffe5f4643e64126d5731ce8d173d36f62fa43d6eb6f7"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/93/c4/d8fa5dfcfef8aa3144ce4cfe4a87a7428b9f78989d65e9b4aa0f0beda5a8/libarchive-c-4.0.tar.gz"
    sha256 "a5b41ade94ba58b198d778e68000f6b7de41da768de7140c984f71d7fa8416e5"
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
    venv = virtualenv_create(libexec, "python3.11")
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
