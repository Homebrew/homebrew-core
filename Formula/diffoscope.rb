class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/32/9b/9ba7a28fc2bd03cd5b9ae0ede2ffd1b000ea630ed8933ad226087ccb267b/diffoscope-209.tar.gz"
  sha256 "e845a0b6cd56c116fee670ae8497512489504dc911201bd77b7d65b8550618f6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22ba31ecddf9f51cad62f2321b143440dbf8c27cc011dc7051e1e8ff89b5a405"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca0e9c77bc9e99411f3b943da77aba22ade88bd60b32a7a8f951aa3f8040c06c"
    sha256 cellar: :any_skip_relocation, monterey:       "c64478e96828b9d84308d6ba73a2af6d8b5c06ca7d810697b72848034568ff7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "80de8b9d60b7bb6e591fab05ba33a5e7165934fd5993427cdad80ae523601d78"
    sha256 cellar: :any_skip_relocation, catalina:       "2e275bf9704a6d376cc16d4ff161fa603368779b549a254a26683ab00d5bdeac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e712752aa159ad9c737c8d290b95bcd4b705425dbafd9609dc7333e8f5dfae3"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.10"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
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
    url "https://files.pythonhosted.org/packages/f7/46/fecfd32c126d26c8dd5287095cad01356ec0a761205f0b9255998bff96d1/python-magic-0.4.25.tar.gz"
    sha256 "21f5f542aa0330f5c8a64442528542f6215c8e18d2466b399b0d9d39356d83fc"
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
