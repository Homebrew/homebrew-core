class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/86/79/5c6302005ff14577e712cc8d0dd944ac65dfee6d64c1a6b7e703c9a846ff/diffoscope-243.tar.gz"
  sha256 "3ce7ff00d72ffd9c904d1d93a4a147208878f56e8f0286073533615689d840b1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "364b3a2cd4733801dd9002274a18c2396e673fb5e5862a36dfd4746996b621a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71d0c2cc284dbcce0b36eff8236fe7bccb1af29f6068479ce3bf7eb29be84bda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "099d5a23cc280bae68a6ce834f89b2c06ee8f54b34aaf8b48d96b33f21b28e58"
    sha256 cellar: :any_skip_relocation, ventura:        "d7cd99a885d38bfdc60a381d29b36f46e47362d66816cc84c20fc64a4a1dfa2b"
    sha256 cellar: :any_skip_relocation, monterey:       "971cab3fd8f4e04f628ea3ed60995816200188e714b22c3637459fa0b283b4f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "102325af487000a2c33c834d03cc1e60b7820dc85a9da45e24341f196c7d9c9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1528fb9722db4f11c402f39edcfdb24ab8566f4db6b84b14d250a600e8914cda"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.11"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/54/c9/41c4dfde7623e053cbc37ac8bc7ca03b28093748340871d4e7f1630780c4/argcomplete-3.1.1.tar.gz"
    sha256 "6c4c563f14f01440aaffa3eae13441c5db2357b5eec639abe7c0b15334627dff"
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
