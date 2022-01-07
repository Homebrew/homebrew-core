class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/b4/be/8443fa6d39522250eb50ac9234e9d6e5e63d29383711e975dbacb39f520c/diffoscope-199.tar.gz"
  sha256 "7b07b8ff34e5fe0e57acc8b02bcb9303ae254c40f357fb7ed805e9f9f7c7686f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a611e16106b59a7b939f124ddf5310fb49104f6ef62c39fdedcf52ad68828afb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aebf88f65ba0a4d332b134a1ce62652585fbf6e9ea660e9deafc180d652f9589"
    sha256 cellar: :any_skip_relocation, monterey:       "fa6e07989901c78be2a7843e223ba509d91d11f9602e5495002e7d87798d9e59"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f3b4074e4a1dbc5571db956975af442955770a124a5ecfa1052e0cc5cd506d5"
    sha256 cellar: :any_skip_relocation, catalina:       "3975e92b6aa36c64cbf18fe6619001ea28d33a7de0a2b697a27f7cc14469da1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba3a1092fbbbf8a9020a7770db3842ecfe542219ca26c313d28ec84dbd200653"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.10"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/0c/91/bf5e8861ab011752fd9f2680ffd9a130cd3990badc722f0e020da2646c28/libarchive-c-3.2.tar.gz"
    sha256 "21ad493f4628972fc82440bff54c834a9fbe13be3893037a4bad332b9ee741e5"
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
