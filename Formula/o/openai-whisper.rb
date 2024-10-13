class OpenaiWhisper < Formula
  include Language::Python::Virtualenv

  desc "General-purpose speech recognition model"
  homepage "https://github.com/openai/whisper"
  url "https://files.pythonhosted.org/packages/ed/a9/81f65f3443778a1e1088e80089fc970f1f160abec2bfc3d71abfed8cbc34/openai-whisper-20240927.tar.gz"
  sha256 "5b322442b03704e245e3d6d3a577d7a3845f884e50edbf15990cb26a134dffff"
  license "MIT"
  head "https://github.com/openai/whisper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4092af8c5fad2fee89cd1f28b82b626e50b19d176f2ef219e0cd0bb756a56e75"
    sha256 cellar: :any,                 arm64_sonoma:  "56f16928126b8bee871d9318a75b5b45dd75bb986c894791a3256162d05e3077"
    sha256 cellar: :any,                 arm64_ventura: "e6350871277be207c949e3167831437174a2d46e9d7c58d62da81d3496763ce0"
    sha256 cellar: :any,                 sonoma:        "b4dec42f4aa1753adf2f1220dd2543649d0652d952b47131116f8b3a0c0939a9"
    sha256 cellar: :any,                 ventura:       "fa170824bcd2e7d2435c1316cdd0bb4c10d1eb615f102b3ccd8593867a8c9c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0d9d31767023ccc24c34d321d558b3a354f328f76938157c640ee5fdfdc5060"
  end

  depends_on "rust" => :build # for tiktoken
  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "llvm@16" # LLVM 17 PR: https://github.com/numba/llvmlite/pull/1042
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "pytorch"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
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
    # Fetch from Git hash for numpy 2.1 compatibility.
    # Use git checkout to avoid .gitattributes causing checksum changes and unknown version info
    url "https://github.com/numba/numba.git",
        revision: "a344e8f55440c91d40c5221e93a38ce0c149b803"
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
    url "https://files.pythonhosted.org/packages/c4/4a/abaec53e93e3ef37224a4dd9e2fc6bb871e7a538c2b6b9d2a6397271daf4/tiktoken-0.7.0.tar.gz"
    sha256 "1077266e949c24e0291f6c350433c6f0971365ece2b173a23bc3b9f9defef6b6"
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
