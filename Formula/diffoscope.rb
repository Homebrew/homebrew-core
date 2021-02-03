class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/82/0b/abc82afbcc451271df4bf027a6f9442f4d7a512c48e7f94d5f3e88a4bea8/diffoscope-166.tar.gz"
  sha256 "20d0b4091ae535dc7d094bf5f366e0687e0b4337a268254b11925b8e7c9ea9c4"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9f653b6e9b2c87e5bd8b7510393ca221ffbb41091ab3d7c845e6bac72702e92b"
    sha256 cellar: :any_skip_relocation, big_sur:       "1ba45f252714dd8d0ad8c06b1faf096ef3b1c9eecf2a3404fc88280e085ff1b2"
    sha256 cellar: :any_skip_relocation, catalina:      "a8bf294f2d6bf89b91ea4813524125d2290eee907c464e1fb1b9bfa807954b83"
    sha256 cellar: :any_skip_relocation, mojave:        "93271ba0f90255a8a93e2bd4d75701b9e4404fed70c27bb4dd97bcebe6d386a2"
  end

  depends_on "gnu-tar"
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
