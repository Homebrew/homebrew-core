class OpenaiWhisper < Formula
  include Language::Python::Virtualenv

  desc "General-purpose speech recognition model"
  homepage "https://github.com/openai/whisper"
  url "https://files.pythonhosted.org/packages/78/ef/74ad84ad319fb9be8798ecccdd6384d346b63b54dffb8478234c43f778a1/openai-whisper-20230918.tar.gz"
  sha256 "32a1ee39c3faaf6c719e3a83f1aacc8e164aad87976350371e26845271287c30"
  license "MIT"
  head "https://github.com/openai/whisper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2d24b8a546c11d3873e5749773ae5df0e25b0af9f914ff71b738c738a55357f8"
    sha256 cellar: :any,                 arm64_ventura:  "c7179f5980e02993fc8095d5d41cf1cad3c68f555d641f2c5d369f2f92afaa81"
    sha256 cellar: :any,                 arm64_monterey: "848285bfb9063e56bfc038afaea4755033744a2bd27b6243fa4c00801df4a866"
    sha256 cellar: :any,                 sonoma:         "560e857469f1f92c9c87c5307ffbee0fef86908b842fb6e792acff30daa3b9f3"
    sha256 cellar: :any,                 monterey:       "4b82f5143005fd6d3f454ea7301d6c0f32a9b625c630cbe7f708438abca20536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "296436b37fba46ebc1d64aaf52865394b6163445c25449fabb2d429e3f3f9c36"
  end

  depends_on "rust" => :build # for tiktoken
  depends_on "ffmpeg"
  depends_on "huggingface-cli"
  depends_on "llvm@14"
  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "pytorch"
  depends_on "pyyaml"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "llvmlite" do
    url "https://files.pythonhosted.org/packages/95/e0/369f1c0613c9532319ed3307f4289afc8338d3bf71c1875fdf43603a2d19/llvmlite-0.40.1.tar.gz"
    sha256 "5cdb0d45df602099d833d50bd9e81353a5e036242d3c003c5b294fc61d1986b4"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/2d/73/3557e45746fcaded71125c0a1c0f87616e8258c78391f0c365bf97bbfc99/more-itertools-10.1.0.tar.gz"
    sha256 "626c369fa0eb37bac0291bce8259b332fd59ac792fa5497b59837309cd5b114a"
  end

  resource "numba" do
    url "https://files.pythonhosted.org/packages/f0/51/cc9d67b9357ac04e7c838dfa880acbfee0c15e02ca5a35b3e064a36131f7/numba-0.57.1.tar.gz"
    sha256 "33c0500170d213e66d90558ad6aca57d3e03e97bb11da82e6d87ab793648cb17"
  end

  # numba needs to support numpy 1.25, https://github.com/numba/numba/issues/8698
  resource "numpy" do
    url "https://files.pythonhosted.org/packages/a4/9b/027bec52c633f6556dba6b722d9a0befb40498b9ceddd29cbe67a45a127c/numpy-1.24.4.tar.gz"
    sha256 "80f5e3a4e498641401868df4208b74581206afbee7cf7b8329daae82676d9463"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/4f/1d/6998ba539616a4c8f58b07fd7c9b90c6b0f0c0ecbe8db69095a6079537a7/regex-2023.8.8.tar.gz"
    sha256 "fcbdc5f2b0f1cd0f6a56cdb46fe41d2cce1e644e3b68832f3eeebc5fb0f7712e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/8e/3a/20704b89b271cfebb1c981ef9f172fb18cb879b5c5cfc3b209083f71b229/tiktoken-0.3.3.tar.gz"
    sha256 "97b58b7bfda945791ec855e53d166e8ec20c6378942b93851a6c919ddf9d0496"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
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
