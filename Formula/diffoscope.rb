class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/ad/83/93ea946442700cdced602dcec9b653ad335920d42937db774aad07cfcf16/diffoscope-205.tar.gz"
  sha256 "64d95c926baf934ddcc21863711eee3c21867e9073d86f74bf33604a1d1227b8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5919e4b005a93a9e13d0aad004e52d9521cca6e0a5b1e2117675e88ff3856d49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebad24e51794fea3b0ef7877a3979a8aef5ce33c4b0618fc4689ddcc25291229"
    sha256 cellar: :any_skip_relocation, monterey:       "602c780442e817168b780dcc9132824fc77dadd5fb292f133c4ef99f4652cbcf"
    sha256 cellar: :any_skip_relocation, big_sur:        "faca6bc580e9b87824e3e46f595a853f8a01daeb94b81dd86af4fe7e740b3eca"
    sha256 cellar: :any_skip_relocation, catalina:       "920b9a52ce7b42c451381b36fa7ce2025b9108101ce6b7fd985cc8ca610d822e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9855c386547d5fe7116989de4c7cc25463b9a70093641ec3bafe01096c92b4d"
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
