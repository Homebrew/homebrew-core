class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/fd/ff/2d5beed6cb6cff0ff6d74183c2e961f376c32138cc6e455087203ca0b0b2/diffoscope-192.tar.gz"
  sha256 "ae2774334fce7905f1b938a155d487d55b9fef9da9a9d18eda3d74951a8a8084"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39e5fa1beb669d68d29baa6d2ec180ebf83313a322ce81496d307f342cdc30f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40b64d38cfacbd8ed350c2332d52df29a9f7f4142a77aad5d06c947f9b65e254"
    sha256 cellar: :any_skip_relocation, monterey:       "c6bba1ed5ada73a401d72d2826b62cec8d6ce916b14cdae5ed173cfda7f06d23"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce0d4ba1aae691b58a92b03ad5b5be07af309ba3a7c5dbee23a15478cb48d333"
    sha256 cellar: :any_skip_relocation, catalina:       "f68df0df1f7e5447cbf71ee7c9791dbc17d8929ab18ae6d38d9bed6c5f6e1f49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fe5367218478597a0bd2b6ea49deb3e924b272a3451e90d78d34372372ff868"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.10"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6a/b4/3b1d48b61be122c95f4a770b2f42fc2552857616feba4d51f34611bd1352/argcomplete-1.12.3.tar.gz"
    sha256 "2c7dbffd8c045ea534921e63b0be6fe65e88599990d8dc408ac8c542b72a5445"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/53/d5/bee2190570a2b4c372a022f16ebfc2313ff717a023f277f5d6f9ebf281a2/libarchive-c-3.1.tar.gz"
    sha256 "618a7ecfbfb58ca15e11e3138d4a636498da3b6bc212811af158298530fbb87e"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/3a/70/76b185393fecf78f81c12f9dc7b1df814df785f6acb545fc92b016e75a7e/python-magic-0.4.24.tar.gz"
    sha256 "de800df9fb50f8ec5974761054a708af6e4246b03b4bdaee993f948947b0ebcf"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install libexec/"bin/diffoscope"
    libarchive = Formula["libarchive"].opt_lib/shared_library("libarchive")
    bin.env_script_all_files(libexec/"bin", LIBARCHIVE: libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system "#{bin}/diffoscope", "--progress", "test1", "test2"
  end
end
