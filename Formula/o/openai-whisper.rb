class OpenaiWhisper < Formula
  include Language::Python::Virtualenv

  desc "General-purpose speech recognition model"
  homepage "https://github.com/openai/whisper"
  url "https://files.pythonhosted.org/packages/d2/6e/50ace2bf704e5ffc786d20d96403ab0d57c5d6ab8729de7fed8c436687df/openai-whisper-20231117.tar.gz"
  sha256 "7af424181436f1800cc0b7d75cf40ede34e9ddf1ba4983a910832fcf4aade4a4"
  license "MIT"
  revision 1
  head "https://github.com/openai/whisper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c4558795bc01f4cf23643127bb7359e308359f3a40b50f33dfc51cff1887c5c4"
    sha256 cellar: :any,                 arm64_ventura:  "f1dfa27ec30b0093f91f000563197379d09dc78509eb189fcb9d78f323d7a230"
    sha256 cellar: :any,                 arm64_monterey: "d42281bcbdf8001377055a0caf11769dd9c77c0c7bb5b42de69be3fb9bf519b7"
    sha256 cellar: :any,                 sonoma:         "ff7546711bcf514a9431723ea4f6e927c2dd6a8ef5feaf0db9b26e2cbda3d7a4"
    sha256 cellar: :any,                 ventura:        "0d72c3bc29073f73b6f510874d14203807d836f2b6b5d6318957cb1a59dadb3e"
    sha256 cellar: :any,                 monterey:       "e2dc74cdba852609e96f54449b9d445797b09632bead78271fc3d84a70c3b3a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9afc64c404c6c4d30aa40fa45e5aabab467e0051df557caddef9a0f718d0ed40"
  end

  depends_on "python-setuptools" => :build
  depends_on "rust" => :build # for tiktoken
  depends_on "ffmpeg"
  depends_on "huggingface-cli"
  depends_on "llvm@14" # Issue for newer LLVM: https://github.com/numba/llvmlite/issues/914
  depends_on "numpy"
  depends_on "python-certifi"
  depends_on "python-markupsafe"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pytorch"
  depends_on "pyyaml"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
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
    url "https://files.pythonhosted.org/packages/a3/5e/ad8f7a2ca55b5903cea0aa6ec0bb0eee7faeec3ca1c4f871d99ff46aad36/numba-0.59.0.tar.gz"
    sha256 "12b9b064a3e4ad00e2371fc5212ef0396c80f41caec9b5ec391c8b04b6eaf2a8"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b5/39/31626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853/regex-2023.12.25.tar.gz"
    sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/a7/e8/0dc09862a2a7dddbd8578dbde80cff77a2efec8ecf476eaeab1dc75dffac/tiktoken-0.5.2.tar.gz"
    sha256 "f54c581f134a8ea96ce2023ab221d4d4d81ab614efa0b2fbce926387deb56c80"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/cc/abf6746cc90bc52df4ba730f301b89b3b844d6dc133cb89a01cfe2511eb9/urllib3-2.2.0.tar.gz"
    sha256 "051d961ad0c62a94e50ecf1af379c3aba230c66c710493493560c0c223c49f20"
  end

  def install
    python3 = "python3.12"
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
    system bin/"whisper", "tests", "--model", "tiny.en", "--model_dir", "models", "--output_format", "txt"
    transcription = File.read("tests.txt")
    assert_equal transcription, <<~EOS
      And so, my fellow Americans ask not what your country can do for you
      ask what you can do for your country.
    EOS
  end
end
