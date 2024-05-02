class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/c5/d7/08af59ef7ddd175428ba44bc3fbbbd2ad92b55232de68d35346a87b2dd8e/diffoscope-265.tar.gz"
  sha256 "7bdcbd7fc5bc4c821bf6ab5ffbbeb265103b04e6908ea4bb12144d7e5ca002ff"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2729da270f33dd368bd89b12e980f9935600a9a04215cf671461fcaa4e6ae97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2729da270f33dd368bd89b12e980f9935600a9a04215cf671461fcaa4e6ae97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2729da270f33dd368bd89b12e980f9935600a9a04215cf671461fcaa4e6ae97"
    sha256 cellar: :any_skip_relocation, sonoma:         "c42e31298ca3794f662a2186592c23698d023de900d39c22f9d9745424df94fb"
    sha256 cellar: :any_skip_relocation, ventura:        "c42e31298ca3794f662a2186592c23698d023de900d39c22f9d9745424df94fb"
    sha256 cellar: :any_skip_relocation, monterey:       "c42e31298ca3794f662a2186592c23698d023de900d39c22f9d9745424df94fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29702158d33ec2dca82c6dd2e74d3727e7b14b1bf59f52a5e2da1107bcefc68a"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/79/51/fd6e293a64ab6f8ce1243cf3273ded7c51cbc33ef552dce3582b6a15d587/argcomplete-3.3.0.tar.gz"
    sha256 "fd03ff4a5b9e6580569d34b273f741e85cd9e072f3feeeee3eba4891c70eda62"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/a0/f9/3b6cd86e683a06bc28b9c2e1d9fe0bd7215f2750fd5c85dce0df96db8eca/libarchive-c-5.1.tar.gz"
    sha256 "7bcce24ea6c0fa3bc62468476c6d2f6264156db2f04878a372027c10615a2721"
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
