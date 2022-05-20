class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/1f/cf/e98d1a0031fc8d1ee970a150147c2b834297eb521124738844d4d7e9d0c3/diffoscope-212.tar.gz"
  sha256 "744260ccf2bb869c58c50dfab68957dd494b12e446520993d0925b2394ea1db7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd4a46698f886697402b2de8573ca8071714f21cbf9ed78074f83b955a12d2f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8467c760deaac81d830239ba0d006d0d9ad9878ea14026c7947ad1c40da628d5"
    sha256 cellar: :any_skip_relocation, monterey:       "d291503daa57bc005c74feda5c1bdfb5e89dacbb4cb4025cf131c655a9eb8e2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "be6da117944c0ff904764241a7f0d872f6eec70d02654d879554499136ebfa9e"
    sha256 cellar: :any_skip_relocation, catalina:       "cc39f556fa88fffc43869637b104c90fee4b9d6377867f229ef0532b3a17cca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "705e29a2d0238e8b008f5262448da9469fa4675429a81f474b0145616ef2e390"
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
