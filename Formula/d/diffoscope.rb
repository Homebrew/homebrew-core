class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/c8/ad/45a8968662534e87b49704f74989e6923c9f87eb809cd7644008e0ca5431/diffoscope-301.tar.gz"
  sha256 "2b46b60afe3fbb9ba79946e5196157b272ddad27692ccf5e4839def1ef3019c6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6db2a0e0f53bb3e6d3258d483d51f231a71ffe7dfa80231a9a65a86caa9e205"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6db2a0e0f53bb3e6d3258d483d51f231a71ffe7dfa80231a9a65a86caa9e205"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6db2a0e0f53bb3e6d3258d483d51f231a71ffe7dfa80231a9a65a86caa9e205"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e0540b6d76c91bea0cafa199d0c0df92b6ef763134330aa2f4a5efe4ea5900c"
    sha256 cellar: :any_skip_relocation, ventura:       "5e0540b6d76c91bea0cafa199d0c0df92b6ef763134330aa2f4a5efe4ea5900c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2561612504ecf31a231cd006fa9731fb03ed34e7dabc20b59fb0fb3c1bca3051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2561612504ecf31a231cd006fa9731fb03ed34e7dabc20b59fb0fb3c1bca3051"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/26/23/e72434d5457c24113e0c22605cbf7dd806a2561294a335047f5aa8ddc1ca/libarchive_c-5.3.tar.gz"
    sha256 "5ddb42f1a245c927e7686545da77159859d5d4c6d00163c59daff4df314dae82"
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
    venv = virtualenv_create(libexec, "python3.13")
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
