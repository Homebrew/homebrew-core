class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/ff/ed/e7fb1f2aa673439522727ea943707f7e03e6fcf01e3b85149542f18a616c/diffoscope-207.tar.gz"
  sha256 "e670160911c8e465ab178f23bd1a2e6a827032b7bbec5f24eebf9215f1ae5f54"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0ac2c964aa4d82d8a2d1a87ef9ef0f09015cf158ec606121f74452feff8a7ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "001753a3510ca3e6d43548be2e20417362ce29f0634c9ca0e5aca0f0e76b8bf0"
    sha256 cellar: :any_skip_relocation, monterey:       "7f745375de181b6c99c0ac0d1219242bdf6ca9c9cb770fd7d7ac35999d1949eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "471709df2ab03481db83e1c853e35ed82afaafe36fbeff192d070dfce7cc0796"
    sha256 cellar: :any_skip_relocation, catalina:       "8d2f1be93405eb95b3ffc286118677f6465a430364e0cabd43f6baa97e421cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9e3c7ff8e53ef2b1e5f24c93c119108337224dbe51a014e2360f5a5fa274702"
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
