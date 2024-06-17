class OpenaiWhisper < Formula
  include Language::Python::Virtualenv

  desc "General-purpose speech recognition model"
  homepage "https://github.com/openai/whisper"
  url "https://files.pythonhosted.org/packages/d2/6e/50ace2bf704e5ffc786d20d96403ab0d57c5d6ab8729de7fed8c436687df/openai-whisper-20231117.tar.gz"
  sha256 "7af424181436f1800cc0b7d75cf40ede34e9ddf1ba4983a910832fcf4aade4a4"
  license "MIT"
  revision 4
  head "https://github.com/openai/whisper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b8d9f395e267d914117d6bc493aa1bd5ef4cb1ce6add361710fe3ea3a1955e93"
    sha256 cellar: :any,                 arm64_ventura:  "1de0a5e7c6a0022f67b1a9ba1bd69949183dbfe840d523ca9ad7eeff67370030"
    sha256 cellar: :any,                 arm64_monterey: "e85de4c8ac57842a7799ecdf8920c73f1686938cceaf34e957dff87dac81327b"
    sha256 cellar: :any,                 sonoma:         "6ad93c3dd3b56f82ae4bc744a1de932c30f08abc85a92846937f97d276be6fd2"
    sha256 cellar: :any,                 ventura:        "6f25ca02cc226485fe3ea8fa6180cf3ccef4a3bb75481d6e1b9dfab37db19c37"
    sha256 cellar: :any,                 monterey:       "04cd9a0ee92292cbe3adfd474e361c47d7733163f7e868f39f9418d1af34092d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0feb6cf80e3652aa9e0b43d74e25581c36025b9aa48cff2d3b7226a712263704"
  end

  depends_on "rust" => :build # for tiktoken
  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "llvm@14" # Issue for newer LLVM: https://github.com/numba/llvmlite/issues/914
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
    url "https://files.pythonhosted.org/packages/3b/ff/ad02ffee7d519615726fc46c99a37e697f2b4b1fb7e5d3cd6fb465d4f49f/llvmlite-0.42.0.tar.gz"
    sha256 "f92b09243c0cc3f457da8b983f67bd8e1295d0f5b3746c7a1861d7a99403854a"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/df/ad/7905a7fd46ffb61d976133a4f47799388209e73cbc8c1253593335da88b4/more-itertools-10.2.0.tar.gz"
    sha256 "8fccb480c43d3e99a00087634c06dd02b0d50fbf088b380de5a41a015ec239e1"
  end

  resource "numba" do
    url "https://files.pythonhosted.org/packages/bb/84/468592513867604800592b58d106f5e7e6ef61de226b59c1e9313917fbbb/numba-0.59.1.tar.gz"
    sha256 "76f69132b96028d2774ed20415e8c528a34e3299a40581bae178f0994a2f370b"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/7a/db/5ddc89851e9cc003929c3b08b9b88b429459bf9acbf307b4556d51d9e49b/regex-2024.5.15.tar.gz"
    sha256 "d3ee02d9e5f482cc8309134a91eeaacbdd2261ba111b0fef3748eeb4913e6a2c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/86/ec/535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392db/requests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/c4/4a/abaec53e93e3ef37224a4dd9e2fc6bb871e7a538c2b6b9d2a6397271daf4/tiktoken-0.7.0.tar.gz"
    sha256 "1077266e949c24e0291f6c350433c6f0971365ece2b173a23bc3b9f9defef6b6"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/5a/c0/b7599d6e13fe0844b0cda01b9aaef9a0e87dbb10b06e4ee255d3fa1c79a2/tqdm-4.66.4.tar.gz"
    sha256 "e4d936c9de8727928f3be6079590e97d9abfe8d39a590be678eb5919ffc186bb"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    python3 = "python3.12"
    venv = virtualenv_create(libexec, python3)

    # We depend on pytorch, but that's a separate formula, so install a `.pth` file to link them.
    # This needs to happen _before_ we try to install torchvision.
    site_packages = Language::Python.site_packages(python3)
    pytorch = Formula["pytorch"].opt_libexec
    (libexec/site_packages/"homebrew-pytorch.pth").write pytorch/site_packages

    ENV["LLVM_CONFIG"] = Formula["llvm@14"].opt_bin/"llvm-config"
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
    system "#{bin}/whisper", "tests", "--model", "tiny.en", "--model_dir", "models", "--output_format", "txt"
    transcription = File.read("tests.txt")
    assert_equal transcription, <<~EOS
      And so, my fellow Americans ask not what your country can do for you
      ask what you can do for your country.
    EOS
  end
end
