class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/58/ff/586648b295ea0c4711e50cebc460eb04d694a44943775a326e07cf5b2052/diffoscope-208.tar.gz"
  sha256 "2c5c0ac1159eefce158154849fe67f0f527dffc5295bfd3ca1aef14962ffcbcb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07fd2ff39bc41154b811cde2494ab4acd1505762d457ec14fb158758b7d24297"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af30249f3b2c8bfcdd01a8f2d94e47c2073ad34a7e8e91b33b1b425b48c24c61"
    sha256 cellar: :any_skip_relocation, monterey:       "6ef947113513233e6b73539a939a77556c1b6cddb47e39d789c5015651705971"
    sha256 cellar: :any_skip_relocation, big_sur:        "197338c1b46763a60c7a5247e0f43fc7cc31341ccc1776b8633d408cfa7da9db"
    sha256 cellar: :any_skip_relocation, catalina:       "2cfa75dcf7e1086b03fd9590fbd25c739806940fc820190c4b352dfbd4776fb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07b776102e3da40dfa78fc84f5c34eeea36b64b4df741a227129a4e055a470bc"
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
