class OpenaiWhisper < Formula
  include Language::Python::Virtualenv

  desc "General-purpose speech recognition model"
  homepage "https://github.com/openai/whisper"
  url "https://files.pythonhosted.org/packages/80/8b/13b7bf32b83fce396a814678661afdb8839b6b4713b3f2f2bc1499888654/openai-whisper-20230314.tar.gz"
  sha256 "7a8e62334f97a8d143b439ae8ed6638d78f41ad921a0205382354004b7271725"
  license "MIT"
  head "https://github.com/openai/whisper.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "2b50faf647c94306e10382f23edc5e417d1ea2729981adc5794dbeb726e7112c"
    sha256 cellar: :any,                 arm64_monterey: "e65e96ce611455d093548ebe8470677e9dd5adb7736a670e5658f86a65bc94af"
    sha256 cellar: :any,                 monterey:       "987fb47740fd27b3501570f99d7f22ce1b5454713d9fbf31ae81c43c0eacfe6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71780b5c1f8bed96dd915f1a37434831ecca2ac472a444d79e5a44d716292f71"
  end

  depends_on "rust" => :build # for tiktoken
  depends_on "ffmpeg"
  depends_on "huggingface-cli"
  depends_on "llvm@14"
  depends_on "python@3.11"
  depends_on "pytorch"
  depends_on "pyyaml"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "ffmpeg-python" do
    url "https://files.pythonhosted.org/packages/dd/5e/d5f9105d59c1325759d838af4e973695081fbbc97182baf73afc78dec266/ffmpeg-python-0.2.0.tar.gz"
    sha256 "65225db34627c578ef0e11c8b1eb528bb35e024752f6f10b78c011f6f64c4127"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/8f/2e/cf6accf7415237d6faeeebdc7832023c90e0282aa16fd3263db0eb4715ec/future-0.18.3.tar.gz"
    sha256 "34a17436ed1e96697a86f9de3d15a3b0be01d8bc8de9c1dffd59fb8234ed5307"
  end

  resource "llvmlite" do
    url "https://files.pythonhosted.org/packages/fe/82/3405e76ec3eac1857002ea79d8ce7e6314e27d025aecddab01e9c0179636/llvmlite-0.40.0rc1.tar.gz"
    sha256 "f87877f4703bbc73b2c1a872a5487f4720031b9ad7bc8e2bf3dc5fe616db6b15"
  end

  resource "numba" do
    url "https://files.pythonhosted.org/packages/f0/51/cc9d67b9357ac04e7c838dfa880acbfee0c15e02ca5a35b3e064a36131f7/numba-0.57.1.tar.gz"
    sha256 "33c0500170d213e66d90558ad6aca57d3e03e97bb11da82e6d87ab793648cb17"
  end

  # numba needs to support numpy 1.25, https://github.com/numba/numba/issues/8698
  resource "numpy" do
    url "https://files.pythonhosted.org/packages/2c/d4/590ae7df5044465cc9fa2db152ae12468694d62d952b1528ecff328ef7fc/numpy-1.24.3.tar.gz"
    sha256 "ab344f1bf21f140adab8e47fdbc7c35a477dc01408791f8ba00d018dd0bc5155"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/d8/29/bd8de07107bc952e0e2783243024e1c125e787fd685725a622e4ac7aeb3c/regex-2023.3.23.tar.gz"
    sha256 "dc80df325b43ffea5cdea2e3eaa97a44f3dd298262b1c7fe9dbb2a9522b956a7"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/fb/d9/c38fee002c5979f29c182aee8e28c31538eabf40022e304f97ff82324199/tiktoken-0.3.1.tar.gz"
    sha256 "8295912429374f5f3c6c6bf053a091ce1de8c1792a62e3b30d4ad36f47fa8b52"
  end

  resource "test-audio" do
    url "https://raw.githubusercontent.com/openai/whisper/7858aa9c08d98f75575035ecd6481f462d66ca27/tests/jfk.flac"
    sha256 "63a4b1e4c1dc655ac70961ffbf518acd249df237e5a0152faae9a4a836949715"
  end

  resource "test-model" do
    url "https://openaipublic.azureedge.net/main/whisper/models/d3dd57d32accea0b295c96e26691aa14d8822fac7d9d27d5dc00b4ca2826dd03/tiny.en.pt"
    sha256 "d3dd57d32accea0b295c96e26691aa14d8822fac7d9d27d5dc00b4ca2826dd03"
  end

  def install
    python3 = "python3.11"
    venv = virtualenv_create(libexec, python3)
    ENV["LLVM_CONFIG"] = Formula["llvm@14"].opt_bin/"llvm-config"
    venv.pip_install resources.reject { |r| r.name.start_with? "test-" }
    venv.pip_install_and_link buildpath

    # link dependent virtualenvs to this one
    site_packages = Language::Python.site_packages(python3)
    paths = %w[pytorch huggingface-cli].map do |package_name|
      package = Formula[package_name].opt_libexec
      package/site_packages
    end
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")
  end

  test do
    testpath.install resource("test-audio")
    (testpath/"models").install resource("test-model")
    # for some unknown reason, the file is installed as `tests` rather than `jfk.flac`
    system "#{bin}/whisper", "tests", "--model", "tiny.en", "--model_dir", "models", "--output_format", "txt"
    transcription = File.read("tests.txt")
    assert_equal transcription, <<~EOS
      And so, my fellow Americans ask not what your country can do for you
      ask what you can do for your country.
    EOS
  end
end
