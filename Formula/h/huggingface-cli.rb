class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/guides/cli"
  url "https://files.pythonhosted.org/packages/c4/fc/eb9bc06130e8bbda6a616e1b80a7aa127681c448d6b49806f61db2670b61/huggingface_hub-1.4.1.tar.gz"
  sha256 "b41131ec35e631e7383ab26d6146b8d8972abc8b6309b963b306fbcca87f5ed5"
  license "Apache-2.0"
  head "https://github.com/huggingface/huggingface_hub.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f2aa32dc0d0583693bc6655746d40572c68ed3b397d9e6f171a2b699e516cbc1"
    sha256 cellar: :any,                 arm64_sequoia: "43ec35b4f4e60df7351e4d2b0ec98ad934c406e4b5f8bbc085e6aab3d39516e9"
    sha256 cellar: :any,                 arm64_sonoma:  "3e2c36f802733365f267c7bdf7a98e4e2922307e7ffcae12c53d7af145efe7a9"
    sha256 cellar: :any,                 sonoma:        "dcd21ad262ccdcef451c6b11a20d8cec6bee994bb23e50c7a7223e37f0be906f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64095b34248c3d8c3c53f342817565a36de423af52c1a44d7854c967d08e107d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c311f33a7dfcac7e6a23e9d8c0dd43abbe4ab4e0667645ff091aae25671ca9f6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for `hf-xet`

  depends_on "certifi" => :no_linkage
  depends_on "git-lfs"
  depends_on "libyaml"
  depends_on "python@3.14"

  on_linux do
    depends_on "openssl@3"
  end

  pypi_packages package_name:     "huggingface_hub[cli]",
                exclude_packages: "certifi"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/96/f0/5eb65b2bb0d09ac6776f2eb54adee6abe8228ea05b20a5ad0e4945de8aac/anyio-4.12.1.tar.gz"
    sha256 "41cfcc3a4c85d3f05c932da7c26d0201ac36f72abd4435ba90d0464a3ffed703"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/1d/65/ce7f1b70157833bf3cb851b556a37d4547ceafc158aa9b34b36782f23696/filelock-3.20.3.tar.gz"
    sha256 "18c57ee915c7ec61cff0ecf7f0f869936c7c30191bb0cf406f1341778d0834e1"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/51/7c/f60c259dcbf4f0c47cc4ddb8f7720d2dcdc8888c8e5ad84c73ea4531cc5b/fsspec-2026.2.0.tar.gz"
    sha256 "6544e34b16869f5aacd5b90bdf1a71acb37792ea3ddf6125ee69a22a53fb8bff"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/5e/6e/0f11bacf08a67f7fb5ee09740f2ca54163863b07b70d579356e9222ce5d8/hf_xet-1.2.0.tar.gz"
    sha256 "a8c27070ca547293b6890c4bf389f713f80e8c478631432962bb7f4bc0bd7d7f"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
  end

  resource "typer-slim" do
    url "https://files.pythonhosted.org/packages/17/d4/064570dec6358aa9049d4708e4a10407d74c99258f8b2136bb8702303f1a/typer_slim-0.21.1.tar.gz"
    sha256 "73495dd08c2d0940d611c5a8c04e91c2a0a98600cbd4ee19192255a233b6dbfd"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    venv = virtualenv_install_with_resources(without: "hf-xet")

    resource("hf-xet").stage do
      # `hf-xet` sdist has an invalid Python source path in `pyproject.toml`.
      inreplace "pyproject.toml", 'python-source = "hf_xet/python"', 'python-source = "."'

      if ENV.effective_arch == :armv8
        # Disable sha2-asm which requires a minimum of -march=armv8-a+crypto
        inreplace "data/Cargo.toml",
                  'sha2 = { workspace = true, features = ["asm"] }',
                  "sha2 = { workspace = true }"
      end
      venv.pip_install Pathname.pwd
    end

    generate_completions_from_executable(bin/"hf", shell_parameter_format: :typer)
  end

  test do
    ENV["HUGGINGFACE_HUB_CACHE"] = testpath
    ENV["NO_COLOR"] = "1"
    assert_match "Not logged in", shell_output("#{bin}/hf auth whoami")
    assert_match "No cached repositories found.", shell_output("#{bin}/hf cache ls")
  end
end
