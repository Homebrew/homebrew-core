class Hf < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/guides/cli"
  url "https://files.pythonhosted.org/packages/35/97/2eb4abaa5b969ed385066a0496a3823b3ff467fc1082e2202955f1867d60/huggingface_hub-1.30.0.tar.gz"
  sha256 "e6a6120bc8c8e2723d03648434ee247088cceb55ba7067e7d34d692cad5fdb57"
  license "Apache-2.0"
  head "https://github.com/huggingface/huggingface_hub.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a87d83478cf1a318e13c767fdd3ec67d8a5abc90ff7ada0e825f63bf6671e091"
    sha256 cellar: :any, arm64_sequoia: "80d02ce7c8c572a3445af0600772ac2f5275e71c4ddc1f18d06e6d4fe70b9427"
    sha256 cellar: :any, arm64_sonoma:  "ed829ab065c9dfb6d377c5bdc0fe1b49d6a4c1b79c7b79f82334dad046afb989"
    sha256 cellar: :any, arm64_linux:   "4e480f482443c5af7f8d5fba7e6cd04dd5a82d404ab5d56ec1322ee42acf66f3"
    sha256 cellar: :any, x86_64_linux:  "3098dbe91b8ebb3d1b893d68880b559ccc241fbaa6502d45c88b0858991d2a0f"
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
    url "https://files.pythonhosted.org/packages/ea/9a/c15a60547004a3f3cea20296c934f827ddd7bdba225a2e7e9fcb5ec48c80/anyio-4.15.0.tar.gz"
    sha256 "b5c620ed540725e2579c31b17bb995b3bf02c9281c9cace04c7d186380bab85e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/a0/50c2c0ce5e74d7721bbb1b19a26ebd339aac5878553a6e35308c2f31f935/filelock-3.32.5.tar.gz"
    sha256 "f6a6a28f743f9b95ce19db5abe0f376f75eb56517dff21e1a4751e2657d3e83d"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/00/78/f34251dadb8f3921264a1d9b8946f5e542014ee2614b285261b4e40e6775/fsspec-2026.7.0.tar.gz"
    sha256 "c803c40f4cf860b49dea58ee3e1c33cb9c790520e233537e1340049f89b82a88"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/1b/ab/522a2ab67f27971a9d48ca666d4fca85ef7d5282d142e31fd087e27b1bbe/hf_xet-1.6.0.tar.gz"
    sha256 "2e58454a340b3556dfa4972d5451aff4fba8dd42a236600ba1a1d2b1514f0fef"
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
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/21/3b/6c24bec5be5e743ffd99576daa5cc077722fc7d5bbc00bd133fa0c698dc6/tqdm-4.70.0.tar.gz"
    sha256 "55b0b0dbd97462d06ebee91e4dac24ed4d4702be82b24f07e6c1d27e08cea220"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  def install
    venv = virtualenv_install_with_resources(without: "hf-xet")

    resource("hf-xet").stage do
      # Use native-tls instead since building bundled aws-lc is tricky to do indirectly within superenv.
      # Can consider switching if system copy is supported https://github.com/aws/aws-lc-rs/issues/936
      inreplace %w[xet_client/Cargo.toml xet_data/Cargo.toml xet_pkg/Cargo.toml],
                'default = ["rustls-tls"]', 'default = ["native-tls"]'

      venv.pip_install Pathname.pwd
    end

    generate_completions_from_executable(bin/"hf", shell_parameter_format: :click)
  end

  test do
    ENV["HUGGINGFACE_HUB_CACHE"] = testpath
    ENV["NO_COLOR"] = "1"
    assert_match "Not logged in", shell_output("#{bin}/hf auth whoami 2>&1", 1)
    assert_match "No results found.", shell_output("#{bin}/hf cache ls")
  end
end
