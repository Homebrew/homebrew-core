class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/d1/6a/b5c21638401ce35b6b554dbfb1c0ef0639f9f2b845e9f5b45e117ec0570a/diffoscope-168.tar.gz"
  sha256 "c6f1dc3e75b7e2e5ceac4f857fbd2ee0ddb3f0169c2b39ea9187af34208e98de"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9aa3f93172040990b96cb08cea3677db5f3e08c5167ac1a77f3f0ae624707e06"
    sha256 cellar: :any_skip_relocation, big_sur:       "8406e6e94692626871894057be2606cdfa6c01f74d07d5d81015ae922f05d904"
    sha256 cellar: :any_skip_relocation, catalina:      "173899d162e087fec48a638358a7d9e41155beaed23500ee5b3d8d7f96a3d998"
    sha256 cellar: :any_skip_relocation, mojave:        "82372f716ddbb2d887ef46b324964eba39167a20b720bcaa5ccdea3ccdac9cb8"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.9"

  # Use resources from diffoscope[cmdline]
  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/cb/53/d2e3d11726367351b00c8f078a96dacb7f57aef2aca0d3b6c437afc56b55/argcomplete-1.12.2.tar.gz"
    sha256 "de0e1282330940d52ea92a80fea2e4b9e0da1932aaa570f84d268939d1897b04"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/63/fe/9e6c78db381934e28c7ec3d30d4f209fe24442d17f1bd8c56d13ae185cf6/libarchive-c-2.9.tar.gz"
    sha256 "9919344cec203f5db6596a29b5bc26b07ba9662925a05e24980b84709232ef60"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/26/60/6d45e0e7043f5a7bf15238ca451256a78d3c5fe02cd372f0ed6d888a16d5/python-magic-0.4.22.tar.gz"
    sha256 "ca884349f2c92ce830e3f498c5b7c7051fe2942c3ee4332f65213b8ebff15a62"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")
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
