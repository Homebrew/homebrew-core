class OpenaiWhisper < Formula
  include Language::Python::Virtualenv

  desc "General-purpose speech recognition model"
  homepage "https://github.com/openai/whisper"
  url "https://files.pythonhosted.org/packages/35/8e/d36f8880bcf18ec026a55807d02fe4c7357da9f25aebd92f85178000c0dc/openai_whisper-20250625.tar.gz"
  sha256 "37a91a3921809d9f44748ffc73c0a55c9f366c85a3ef5c2ae0cc09540432eb96"
  license "MIT"
  revision 3
  head "https://github.com/openai/whisper.git", branch: "main"

  no_autobump! because: "`update-python-resources` cannot update resource blocks"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "227556d6e6dfa4ca40db7aa725c017e4ce967671ff85f42b9477ce46e7f8e1df"
    sha256 cellar: :any,                 arm64_sequoia: "dbfe8ca53a1fed998d7b76b38666a38f03b1c585c77894a6015b0496f5dee36a"
    sha256 cellar: :any,                 arm64_sonoma:  "1280043e63c3adc589fc189c9e4c3708ad2613a6f6dc2c7ecfe5550f9c353676"
    sha256 cellar: :any,                 sonoma:        "8608f50fb6ba8c16cebfc86c26faf41f777172d9cd80b380ef8b7d236c657b2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec3439c4ebfa0277efa7511e26d5dd748b61a3c37613044429beeb00bb0e7fca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2914c7ea1da587e7adcc447593b7c3ea55e22f7b41214cb5dc6587b41f85321"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for tiktoken
  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "llvm@20"
  depends_on "python@3.14"
  depends_on "pytorch"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "openblas"
  end

  # numba 0.63.1 does not support numpy 2.4.x, see https://github.com/numba/numba/issues/10263
  pypi_packages exclude_packages: %w[certifi torch]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "llvmlite" do
    url "https://files.pythonhosted.org/packages/74/cd/08ae687ba099c7e3d21fe2ea536500563ef1943c5105bf6ab4ee3829f68e/llvmlite-0.46.0.tar.gz"
    sha256 "227c9fd6d09dce2783c18b754b7cd9d9b3b3515210c46acc2d3c5badd9870ceb"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "numba" do
    url "https://files.pythonhosted.org/packages/dc/60/0145d479b2209bd8fdae5f44201eceb8ce5a23e0ed54c71f57db24618665/numba-0.63.1.tar.gz"
    sha256 "b320aa675d0e3b17b40364935ea52a7b1c670c9037c39cf92c49502a75902f4b"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/76/65/21b3bc86aac7b8f2862db1e808f1ea22b028e30a225a34a5ede9bf8678f2/numpy-2.3.5.tar.gz"
    sha256 "784db1dcdab56bf0517743e746dfb0f885fc68d948aba86eeec2cba234bdf1c0"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/cc/a9/546676f25e573a4cf00fe8e119b78a37b6a8fe2dc95cda877b30889c9c45/regex-2025.11.3.tar.gz"
    sha256 "1fedc720f9bb2494ce31a58a1631f9c82df6a09b49c19517ea5cc280b4541e01"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/7d/ab/4d017d0f76ec3171d469d80fc03dfbb4e48a4bcaddaa831b31d526f05edc/tiktoken-0.12.0.tar.gz"
    sha256 "b18ba7ee2b093863978fcb14f74b3707cdc8d4d4d3836853ce7ec60772139931"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    ENV["LLVMLITE_SHARED"] = "1"
    venv = virtualenv_install_with_resources without: "numba"

    # We depend on pytorch, but that's a separate formula, so install a `.pth` file to link them.
    # NOTE: This is an exception to our usual policy as building `pytorch` is complicated
    site_packages = Language::Python.site_packages(venv.root/"bin/python3")
    pth_contents = "import site; site.addsitedir('#{Formula["pytorch"].opt_libexec/site_packages}')\n"
    (venv.site_packages/"homebrew-pytorch.pth").write pth_contents

    # We install `numba` separately without build isolation to avoid building another `numpy`
    venv.pip_install(resource("numba"), build_isolation: false)
  end

  test do
    resource "homebrew-test-audio" do
      url "https://raw.githubusercontent.com/openai/whisper/7858aa9c08d98f75575035ecd6481f462d66ca27/tests/jfk.flac"
      sha256 "63a4b1e4c1dc655ac70961ffbf518acd249df237e5a0152faae9a4a836949715"
    end

    resource "homebrew-test-model" do
      url "https://openaipublic.azureedge.net/main/whisper/models/d3dd57d32accea0b295c96e26691aa14d8822fac7d9d27d5dc00b4ca2826dd03/tiny.en.pt"
      sha256 "d3dd57d32accea0b295c96e26691aa14d8822fac7d9d27d5dc00b4ca2826dd03"
    end

    testpath.install resource("homebrew-test-audio")
    (testpath/"models").install resource("homebrew-test-model")
    # for some unknown reason, the file is installed as `tests` rather than `jfk.flac`
    system bin/"whisper", "tests", "--model", "tiny.en", "--model_dir", "models", "--output_format", "txt"
    assert_equal <<~EOS, (testpath/"tests.txt").read
      And so, my fellow Americans ask not what your country can do for you
      ask what you can do for your country.
    EOS
  end
end
