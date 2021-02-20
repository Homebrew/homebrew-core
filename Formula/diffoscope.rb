class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/82/0b/abc82afbcc451271df4bf027a6f9442f4d7a512c48e7f94d5f3e88a4bea8/diffoscope-166.tar.gz"
  sha256 "20d0b4091ae535dc7d094bf5f366e0687e0b4337a268254b11925b8e7c9ea9c4"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "919cc8a56e5c4f07557fd53336e6f108d3d323a2171a0873c92f2fa278b92b09"
    sha256 cellar: :any_skip_relocation, big_sur:       "4acb598c77b28aca9325e2a1d1b0933d4bc17f72b3734d4408eca1b487be0691"
    sha256 cellar: :any_skip_relocation, catalina:      "0a9db33704a8c0b43af6c21ce2981bb7b566fc84dd91d79416d6541e8e50aecc"
    sha256 cellar: :any_skip_relocation, mojave:        "1253f88bf7ce5ad6eb53310d8dfa6b51059674bfe04ff98ee798b16d0c2ec809"
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
    url "https://files.pythonhosted.org/packages/2a/d5/2ad6bba29e8f6911d0b1719370e11d5961f4ba6f71845f6421c0ba2badb3/python-magic-0.4.20.tar.gz"
    sha256 "0cc52ccad086c377b9194014e3dbf98d94b194344630172510a6a3e716b47801"
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
