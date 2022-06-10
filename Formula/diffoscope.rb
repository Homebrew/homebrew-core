class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/ed/3f/9c5d029cc3eb78ad75e328001d54eadd6dcc7b4c0cc4409851cfe4936207/diffoscope-216.tar.gz"
  sha256 "7809caabf4369a1f1dffb9fa37e247b4326aa3366cabd6ab3eb7de5cb4402c39"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f36ac320723e03e26627fca7aac70bf2b63bbe131b28a43a6c7c28e24e8b475a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68bfd6e8e2667383bd334b30b7cdd0e336dda5430426ed9eb85ad76e06c7d28f"
    sha256 cellar: :any_skip_relocation, monterey:       "541a8b3dcbd5d0a24b1093d798ff7e49a6b9651402489b9ca15bb53788ae2b29"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0850e354f74a9fab39f39f20125dd19c45c4cd08de7c7e1b7c346c437557ac0"
    sha256 cellar: :any_skip_relocation, catalina:       "07fc4d78560a4a2c19ab9f46992759633c59439f3c7dc688d23e058bbe8757a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "891b765768deb0be0b093b9ed7a2876967f2cd5f8f20b8d054f1530993aaa7d1"
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
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
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
