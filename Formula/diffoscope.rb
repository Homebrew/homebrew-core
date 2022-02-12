class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/94/ad/d231d2b44d115440d1f9dcadea61f8a54da06145bc603da7b434e1c3e506/diffoscope-204.tar.gz"
  sha256 "cc99eb4cd9555947b11d6abb7ba83e71234f92ad1372e3b61e934115192ecb4e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "599c9d587cc254b631a204c08041b0d0cf7208c62047218b9ac5420e5326ffba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35a9e5b15541019c14c6ae6c13c081c52d223ddce8c1bbf7aff1dc3939a062d9"
    sha256 cellar: :any_skip_relocation, monterey:       "fc0f0dd9d80b2bac6a6063b8b4155b20b301505f21f743f60bd6b5bdbc41f511"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecaeb7ecb0a524b3154ddae35619372032b6ce762a3899ba2d5b5ce5743e48b1"
    sha256 cellar: :any_skip_relocation, catalina:       "ee1dfb1ad700a819669d65a840a8ceb4f8cff9981b2c39a9dcf553806293f050"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34bcd8980325dc634cc9c270eb67f54033e4a68a1207ee1b662ef09c3aef3e4c"
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
