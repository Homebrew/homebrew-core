class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/99/81/7feff6dd079b9515c33fa29c8ab627c43a554c9ab913454861dbdff8d0bc/diffoscope-227.tar.gz"
  sha256 "0727b64dd78254e4e53beb2d2541b4f0933b601fa4ca34960d0c9abae5cbb6a9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce20322fbe09898cbad9e5a57c97a7d53716771302f38b9c2fbddb9138aa1c35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b62acdc10049bb6802ef2c075169cc520268a58814dbc560e190c3061fca58a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b50209c32e7b08bcb1b95329ff4f832769397fa852ec2f8c545eddcf6ec38346"
    sha256 cellar: :any_skip_relocation, ventura:        "3046209d5d0575cad9c213113ae2df1d1a0c291000d0c7ac050a1a4cb1e2b11d"
    sha256 cellar: :any_skip_relocation, monterey:       "2ae3165a27d879dd81ac101de71eefdf5361622cb251501365b6830049b37261"
    sha256 cellar: :any_skip_relocation, big_sur:        "e43f10f7bf8e999ad0b2b6494d592de102bae24fb8c809a3cfd256f7b7b6070a"
    sha256 cellar: :any_skip_relocation, catalina:       "37821148fecae0b6b8eecfd5aa855bc3e3cd5b3faf05317d646f11a777800649"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d02f46dfbdb819b44465d87e5e04eec3745855a4f8efe0844c3d9bbc11901fd"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.11"

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
    venv = virtualenv_create(libexec, "python3.11")
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
