class OpenaiWhisper < Formula
  include Language::Python::Virtualenv

  desc "General-purpose speech recognition model"
  homepage "https://github.com/openai/whisper"
  url "https://files.pythonhosted.org/packages/d2/6e/50ace2bf704e5ffc786d20d96403ab0d57c5d6ab8729de7fed8c436687df/openai-whisper-20231117.tar.gz"
  sha256 "7af424181436f1800cc0b7d75cf40ede34e9ddf1ba4983a910832fcf4aade4a4"
  license "MIT"
  revision 6
  head "https://github.com/openai/whisper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5c0f66f4da079c643d98a8cf8bb7d7df823977b274735bf84fc173b5cd68936f"
    sha256 cellar: :any,                 arm64_ventura:  "c266e2b5e120c5cc5d1b7526a8187dc5aa8a9ecfc1e92e1de729bb7aa714768b"
    sha256 cellar: :any,                 arm64_monterey: "dbc69a81f7d17c6b27f760a71e41b6328b81f01b62b6210547c1fed9e81bb7bc"
    sha256 cellar: :any,                 sonoma:         "14104b8148c43be9be0854aef4afdd3854affa97e565df5930f10ca5baa81b27"
    sha256 cellar: :any,                 ventura:        "15ee1feba9cd6fa12d172a91bd0fded080b0074540967baedf1dbe4c9662f126"
    sha256 cellar: :any,                 monterey:       "586562313b49a1d38351a153ee8ac9ef627e9c26eebae2dc129aa877dabdeeba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba221a60f8869b137fdd84b272e3c424a593f3fe91af1b0f01d8274b892aaffd"
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
    url "https://files.pythonhosted.org/packages/9f/3d/f513755f285db51ab363a53e898b85562e950f79a2e6767a364530c2f645/llvmlite-0.43.0.tar.gz"
    sha256 "ae2b5b5c3ef67354824fb75517c8db5fbe93bc02cd9671f3c62271626bc041d5"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/01/33/77f586de725fc990d12dda3d4efca4a41635be0f99a987b9cc3a78364c13/more-itertools-10.3.0.tar.gz"
    sha256 "e5d93ef411224fbcef366a6e8ddc4c5781bc6359d43412a65dd5964e46111463"
  end

  resource "numba" do
    url "https://files.pythonhosted.org/packages/3c/93/2849300a9184775ba274aba6f82f303343669b0592b7bb0849ea713dabb0/numba-0.60.0.tar.gz"
    sha256 "5df6158e5584eece5fc83294b949fd30b9f1125df7708862205217e068aabf16"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/7a/db/5ddc89851e9cc003929c3b08b9b88b429459bf9acbf307b4556d51d9e49b/regex-2024.5.15.tar.gz"
    sha256 "d3ee02d9e5f482cc8309134a91eeaacbdd2261ba111b0fef3748eeb4913e6a2c"
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
    url "https://files.pythonhosted.org/packages/5a/c0/b7599d6e13fe0844b0cda01b9aaef9a0e87dbb10b06e4ee255d3fa1c79a2/tqdm-4.66.4.tar.gz"
    sha256 "e4d936c9de8727928f3be6079590e97d9abfe8d39a590be678eb5919ffc186bb"
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
