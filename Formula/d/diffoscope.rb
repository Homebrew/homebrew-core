class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/29/48/7ce3bb2998b6b04a6167e35753c5a6eb089c1f8f2d4602152ee014e859a7/diffoscope-255.tar.gz"
  sha256 "db03f02c9c2c178207dba9d2f9e8be25daf11770e7a87be008ff58a8adb7cd9e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a03b00c3ec4a9c584278b16a111405988a29ca18a0c8da43cbeaf3e2192940b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "598e13184e602c88cbbc5880ef31981adce54e6506b1b179188ad994a1db8a57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cbeb6062a1698c90158238b1dc86c43eac51a82b5daa4a132f2f04d05370b72"
    sha256 cellar: :any_skip_relocation, sonoma:         "d91f08774c03145c68c4ce93c10652c37a6835f3914b4a07562e817c3eae29f9"
    sha256 cellar: :any_skip_relocation, ventura:        "3c90eb89373c38a6867acdb05a7a32aa3dd23baadcc2e15349fe735bff97fd77"
    sha256 cellar: :any_skip_relocation, monterey:       "34c6915dc1cb4c53c35cf4f9b21325a6a221f84fb0612c36ef1ce9ec19c11167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcb59ccd25c7c4372e60215973316264056a531c237da2de503f0b8a5772a076"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python-argcomplete"
  depends_on "python@3.12"

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/59/d6/eab966f12b33a97c78d319c38a38105b3f843cf7d79300650b7ac8c9d349/libarchive-c-5.0.tar.gz"
    sha256 "d673f56673d87ec740d1a328fa205cafad1d60f5daca4685594deb039d32b159"
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
    venv = virtualenv_create(libexec, "python3.12")
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
