class OpenaiWhisper < Formula
  include Language::Python::Virtualenv

  desc "General-purpose speech recognition model"
  homepage "https://github.com/openai/whisper"
  url "https://files.pythonhosted.org/packages/35/8e/d36f8880bcf18ec026a55807d02fe4c7357da9f25aebd92f85178000c0dc/openai_whisper-20250625.tar.gz"
  sha256 "37a91a3921809d9f44748ffc73c0a55c9f366c85a3ef5c2ae0cc09540432eb96"
  license "MIT"
  head "https://github.com/openai/whisper.git", branch: "main"

  no_autobump! because: "`update-python-resources` cannot update resource blocks"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "1cd169f2942f8942a368479d83f5ae0fd8a68104de51a0ffb40b205d1eecfc36"
    sha256 cellar: :any,                 arm64_sequoia: "cb61f56b09b4b160a563824e41d1d2443954f9d9da1b374056570cb93822c5a4"
    sha256 cellar: :any,                 arm64_sonoma:  "eb058d8c012fdaa90ceb76c1912e86c1e6a8eddfce9068d21d27e8f23ce59f13"
    sha256 cellar: :any,                 sonoma:        "1e391ad933a20ce38fadcd5168e35041c127754838479fdade17e616c901d82f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cec7e344024f3e6f68098b51679ae034f81eaa596920d37acbb48a5f4703251"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for tiktoken
  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "llvm@20"
  depends_on "numpy"
  depends_on "python@3.13"
  depends_on "pytorch"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "llvmlite" do
    url "https://files.pythonhosted.org/packages/9d/73/4b29b502618766276816f2f2a7cf9017bd3889bc38a49319bee9ad492b75/llvmlite-0.45.0.tar.gz"
    sha256 "ceb0bcd20da949178bd7ab78af8de73e9f3c483ac46b5bef39f06a4862aa8336"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "numba" do
    url "https://files.pythonhosted.org/packages/e5/96/66dae7911cb331e99bf9afe35703317d8da0fad81ff49fed77f4855e4b60/numba-0.62.0.tar.gz"
    sha256 "2afcc7899dc93fefecbb274a19c592170bc2dbfae02b00f83e305332a9857a5a"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b2/5a/4c63457fbcaf19d138d72b2e9b39405954f98c0349b31c601bfcb151582c/regex-2025.9.1.tar.gz"
    sha256 "88ac07b38d20b54d79e704e38aa3bd2c0f8027432164226bdee201a1c0c9c9ff"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/a7/86/ad0155a37c4f310935d5ac0b1ccf9bdb635dcb906e0a9a26b616dd55825a/tiktoken-0.11.0.tar.gz"
    sha256 "3c518641aee1c52247c2b97e74d8d07d780092af79d5911a6ab5e79359d9b06a"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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
