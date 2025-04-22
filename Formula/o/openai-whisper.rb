class OpenaiWhisper < Formula
  include Language::Python::Virtualenv

  desc "General-purpose speech recognition model"
  homepage "https://github.com/openai/whisper"
  url "https://files.pythonhosted.org/packages/f5/77/952ca71515f81919bd8a6a4a3f89a27b09e73880cebf90957eda8f2f8545/openai-whisper-20240930.tar.gz"
  sha256 "b7178e9c1615576807a300024f4daa6353f7e1a815dac5e38c33f1ef055dd2d2"
  license "MIT"
  revision 1
  head "https://github.com/openai/whisper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fb20c184addee014fbd43a8035592e76c148b5ea8ce30e22fd5b1f17ca38b7aa"
    sha256 cellar: :any,                 arm64_sonoma:  "2ff5f9e031d71cdc3b66795bfadb17c67f9ad75466e695ad601dde1a60dce069"
    sha256 cellar: :any,                 arm64_ventura: "175aba1ee80e67f54dae13ef88f265a53cce12e0acf3c43353a780cf11979573"
    sha256 cellar: :any,                 sonoma:        "60a4054c514839aade340a6f9e394c57f1f6d43e8f85bad84aa775c2aa5d49a3"
    sha256 cellar: :any,                 ventura:       "3b78fc5f446614ae7367a8c8204da6f3af00501437381e40306c904ad1dcad88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1b019e05f4ec4d9a1cab322adc279ec2d89d07b32e0fa48b906902a3eaeb2c6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for tiktoken
  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "llvm@16" # LLVM 17 PR: https://github.com/numba/llvmlite/pull/1042
  depends_on "numpy"
  depends_on "python@3.13"
  depends_on "pytorch"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "llvmlite" do
    # Fetch from Git hash for compatibility with the new version of `numba` below.
    # Use git checkout to avoid .gitattributes causing checksum changes and unknown version info
    url "https://github.com/numba/llvmlite.git",
        revision: "ca123c3ae2a6f7db865661ae509862277ec5d692"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/51/78/65922308c4248e0eb08ebcbe67c95d48615cc6f27854b6f2e57143e9178f/more-itertools-10.5.0.tar.gz"
    sha256 "5482bfef7849c25dc3c6dd53a6173ae4795da2a41a80faea6700d9f5846c5da6"
  end

  resource "numba" do
    # Fetch from Git hash for numpy 2.1 and python 3.13 compatibility.
    # Use git checkout to avoid .gitattributes causing checksum changes and unknown version info
    url "https://github.com/numba/numba.git",
        revision: "391511bcb0b97af8d311cd276a46030774bc30b7"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/f9/38/148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96/regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/37/02/576ff3a6639e755c4f70997b2d315f56d6d71e0d046f4fb64cb81a3fb099/tiktoken-0.8.0.tar.gz"
    sha256 "9ccbb2740f24542534369c5635cfd9b2b3c2490754a78ac8831d99f89f94eeb2"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/58/83/6ba9844a41128c62e810fddddd72473201f3eacde02046066142a2d96cc5/tqdm-4.66.5.tar.gz"
    sha256 "e1020aef2e5096702d8a025ac7d16b1577279c9d63f8375b63083e9a5f0fcbad"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    ENV["LLVM_CONFIG"] = Formula["llvm@16"].opt_bin/"llvm-config"
    inreplace "setup.py", "version=read_version()", "version='#{version}'"
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
