class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/32/ee/7042f6f8c9e7f561b3638a77ab6479a98c1475927a2de63812468575e54d/diffoscope-217.tar.gz"
  sha256 "1e9791e3f718ca809d98fb319b150ce6222a682b4009ea00838b9d8705003950"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ca4fd03f02770bb5e46aecd4e4a96b70721fdae1766e972d03729e489cbf7e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd111c74d9a9be3d44597b68a5cb6c40c343ce64c9bda6e319da0e7ce30ac154"
    sha256 cellar: :any_skip_relocation, monterey:       "d64a733065ab49d622366e030f91dd4b5331dcef0d609e21d9083647f0b63cf6"
    sha256 cellar: :any_skip_relocation, big_sur:        "28e052596e9b8813e76fd6e655b5d8f8430fba3bfcbf35186534eb18e7b4d371"
    sha256 cellar: :any_skip_relocation, catalina:       "68d25842751c49a903296e4bedf3c755c383bb1b4bf4ad9a50be4bc15f83d74e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dca252a1b40c1cd1f7a55fc07ef3599e7ebdfe556e8de672189fdb1b477ef0ac"
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
