class OpenaiWhisper < Formula
  include Language::Python::Virtualenv

  desc "General-purpose speech recognition model"
  homepage "https://github.com/openai/whisper"
  url "https://files.pythonhosted.org/packages/d2/6e/50ace2bf704e5ffc786d20d96403ab0d57c5d6ab8729de7fed8c436687df/openai-whisper-20231117.tar.gz"
  sha256 "7af424181436f1800cc0b7d75cf40ede34e9ddf1ba4983a910832fcf4aade4a4"
  license "MIT"
  revision 5
  head "https://github.com/openai/whisper.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "c4823602582021d71a112cee7b9fd70d7bb346231ac8a064413fbc4fa5feeae4"
    sha256 cellar: :any,                 arm64_ventura:  "dbe1c266af6c9f768aebc92dfb02f0257b823c79835dd20569f8910736c4481d"
    sha256 cellar: :any,                 arm64_monterey: "03f5d31004276a79c6647f3d3acfb23b1458e0b47a5622a7629c3f14bd5cd093"
    sha256 cellar: :any,                 sonoma:         "e718c5ecde8a4a034870eb564cd0644c8980ffef1f9373562a7e88402e7c91b0"
    sha256 cellar: :any,                 ventura:        "e2d29e93aec4325471339f521bcb0948aafcc688ab19206a6cc470378129f287"
    sha256 cellar: :any,                 monterey:       "05ece5b230afd9939107d8c0a327968f697da8713115c2b524678be1eec28ce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3a12abfebd488c81f69346f3bd7c6cfb0bc6f51926893f19c7e298b427d3386"
  end

  depends_on "rust" => :build # for tiktoken
  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "llvm@15" # Issue for newer LLVM: https://github.com/numba/llvmlite/issues/1048
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
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "llvmlite" do
    url "https://files.pythonhosted.org/packages/9f/3d/f513755f285db51ab363a53e898b85562e950f79a2e6767a364530c2f645/llvmlite-0.43.0.tar.gz"
    sha256 "ae2b5b5c3ef67354824fb75517c8db5fbe93bc02cd9671f3c62271626bc041d5"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/92/0d/ad6a82320cb8eba710fd0dceb0f678d5a1b58d67d03ae5be14874baa39e0/more-itertools-10.4.0.tar.gz"
    sha256 "fe0e63c4ab068eac62410ab05cccca2dc71ec44ba8ef29916a0090df061cf923"
  end

  resource "numba" do
    url "https://files.pythonhosted.org/packages/3c/93/2849300a9184775ba274aba6f82f303343669b0592b7bb0849ea713dabb0/numba-0.60.0.tar.gz"
    sha256 "5df6158e5584eece5fc83294b949fd30b9f1125df7708862205217e068aabf16"

    # Fix compat with numpy 2.0.1: https://github.com/numba/numba/pull/9683
    patch do
      url "https://github.com/numba/numba/commit/afb3d168efa713c235d1bb4586722ad6e5dbb0c1.patch?full_index=1"
      sha256 "5045f942be69fe12d0b0f02a4236c01c092f660ee9fa008848b7ebf5cb8fd528"
    end
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/3f/51/64256d0dc72816a4fe3779449627c69ec8fee5a5625fd60ba048f53b3478/regex-2024.7.24.tar.gz"
    sha256 "9cfd009eed1a46b27c14039ad5bbc5e71b6367c5b2e6d5f5da0ea91600817506"
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
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    python3 = "python3.12"
    venv = virtualenv_create(libexec, python3)

    # We depend on pytorch, but that's a separate formula, so install a `.pth` file to link them.
    # This needs to happen _before_ we try to install torchvision.
    site_packages = Language::Python.site_packages(python3)
    pytorch = Formula["pytorch"].opt_libexec
    (venv.site_packages/"homebrew-pytorch.pth").write pytorch/site_packages

    ENV["LLVM_CONFIG"] = Formula["llvm@15"].opt_bin/"llvm-config"
    venv.pip_install resources.reject { |r| r.name == "numba" }
    venv.pip_install(resource("numba"), build_isolation: false)
    venv.pip_install_and_link buildpath
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
    transcription = File.read("tests.txt")
    assert_equal transcription, <<~EOS
      And so, my fellow Americans ask not what your country can do for you
      ask what you can do for your country.
    EOS
  end
end
