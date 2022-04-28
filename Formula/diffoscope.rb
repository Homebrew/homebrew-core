class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/dd/fc/50afe0200d88fa6807052aa566ae33734773dc79d6e042e58d9ff24a046c/diffoscope-211.tar.gz"
  sha256 "8e75f3acb181096632e43935ba7a85304703ac54739810b4523919188367ec03"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d74cb7814397f55c35f76f9dbe864cfdc0a03902528cfb309cc7ab0eaf0ce220"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52d494c8938c20010735dcb726193384408af3008dac401ee116396ed5933050"
    sha256 cellar: :any_skip_relocation, monterey:       "193a0f861f7a0d7a1f256b856aaa5c6d10046bc8ef3b63a5b8cdb741d0832b90"
    sha256 cellar: :any_skip_relocation, big_sur:        "135faf59eed406648c996e4d1eca6f488204a5014305ab9b49dc2ab99562707c"
    sha256 cellar: :any_skip_relocation, catalina:       "430bb630944798b261ab9b3fa44a732e581fe5867027e1d99087c4bc765de37b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c45de5a333d4d58f45269a9c9144e2faa45a066844503fc6b65a0365839c91a0"
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
