class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/03/02/ae906ca830554a7af817855b3c06b96ca1d5b162f8036186ebb3a5e12d9d/diffoscope-266.tar.gz"
  sha256 "47a93aa20f1644d090a131986be50feb3e645d9e8a892bb04c4c11da216769d9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0fa908dc5fe87af0fab7303d9b0374c7303b858d1f310c92e943dc19bdbb1dc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "134a5034c9a40940f1ff23e405c1daf4e5e8b11a4809da5d38cfc42c62842d09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef20b6a5a3332aa0760325349358b3f11f1911f5a106642b49b7014391110e46"
    sha256 cellar: :any_skip_relocation, sonoma:         "6419b46ac4d18dbef6e2a692a438902117c9afb7a885bbff921e94d9c32b4c3e"
    sha256 cellar: :any_skip_relocation, ventura:        "62b32fa034b1b946bd7f4af133b537a4c5c723f8b8eabdad427a9f84170eeffe"
    sha256 cellar: :any_skip_relocation, monterey:       "4942d86e9881ae8ff1950d6d84d7f9f9a364efe9ea4b3f87194b9f3b6bf11b41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19d17d590a6584519d0ff9f92014d27264046eee8a38c36a1c144b793359ee67"
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
