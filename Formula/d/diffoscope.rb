class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/32/16/c9b164d6f5d7ec710a9ab0ecc111ecf6d281f124fa47eebf86acc233f973/diffoscope-257.tar.gz"
  sha256 "1bceee9ca6fe2d7faa2f21daf9f4a83d83e1f1be8b682691b1d985d5e870077f"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b59b17a3af1b264c9f3edaa69da1fa284f6b3369026082c942838a1f41d606ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cf887d98d1be27ddad406516c04a73320188d6aa339e0debe5ed3d8263a1df2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9e2d2e61129ec9e9890dc48acff55d29fdbdcdcbf72e6c1a6de8e76ebe9548d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2b011934134d5d4e431f32af5e73b96ff972850e5f1df33e64c9c472eb24bdd"
    sha256 cellar: :any_skip_relocation, ventura:        "4099eeedba7416fb0a841f545a90b02bbd48e20dc7af74ff991450484794aef7"
    sha256 cellar: :any_skip_relocation, monterey:       "a00c56f440dd219b2e4555d4fd24c2c3d6b15f78dff47ffdc82d21ca94d5495c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92f70e838acbe414c2aac428b246f4afb2b2380a59afe422f273afba7ba2ecea"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/f0/a2/ce706abe166457d5ef68fac3ffa6cf0f93580755b7d5f883c456e94fab7b/argcomplete-3.2.2.tar.gz"
    sha256 "f3e49e8ea59b4026ee29548e24488af46e30c9de57d48638e24f54a1ea1000a2"
  end

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
