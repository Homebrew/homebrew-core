class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/d6/13/d2c9f32aaf2f90a51ff84e0ea69c5ea6e0867f7f8faccdd39141da8239a6/diffoscope-165.tar.gz"
  sha256 "c25b9e4f03ee6c1ad94024a95bd4e572d25372ed457b6cb7ef18cb01d9fdf9a4"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fe14f34879e07c0d0b9296da3f6a423920390abb261f97c132a233b4b73a28bd" => :big_sur
    sha256 "b1c4bef0c194f34d6e1acca358224a8e6897140590e3c90138120d4f93d595ef" => :arm64_big_sur
    sha256 "2eff4543a80d793ed35b0710af3c1be9e4fcdaf94ad7a46e5f7a7e6901bf0333" => :catalina
    sha256 "407ba3201357bef783ce1a457a12df99064aaefc6ca11372052909ae8a5afd90" => :mojave
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
