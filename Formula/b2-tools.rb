class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v2.1.0.tar.gz"
  sha256 "7fbc25e5d7ef5b88ff870f95ae8f100dd194448ae86d0ed6bd029d50897f44d5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "d264b66cfb7d841a069d900e3a5fdfc8003d45de20298df1207b42573de4280f" => :big_sur
    sha256 "538e37a8d0dfc0ede9d899119e19f02243d2b17ad5a27d8446ca87a8428df43e" => :arm64_big_sur
    sha256 "afdab50c5e6398ac74355674473569b5f6dbd3e43bdeaaf9fe27dea19cabac4d" => :catalina
    sha256 "0d46e13619fb6fb5fa27c2bf5abb276d484ed12eba08366c6d3794b2b574a70e" => :mojave
    sha256 "e93427f054a8360d0dec4ff73a71f25e938bb427b51bd860a3d1bde035a2bc2b" => :high_sierra
  end

  depends_on "python@3.9"

  conflicts_with "boost-build", because: "both install `b2` binaries"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/ec/74/1cf2d9912921cebdba3fa954949206c8aa159c9cc803b88140fb227f8a0e/arrow-0.17.0.tar.gz"
    sha256 "ff08d10cda1d36c68657d6ad20d74fbea493d980f8b2d45344e00d6ed2bf6ed4"
  end

  resource "b2sdk" do
    url "https://files.pythonhosted.org/packages/50/4c/2e00d4f1e45692f66132c539edb3f9f3fc0a8938c6d49c151d1f72bb6fc2/b2sdk-1.2.0.tar.gz"
    sha256 "8e46ff9d47a9b90d8b9beab1969fcf4920300b02e20e6bf0745be04e09e8a6ff"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/e6/de/879cf857ae6f890dfa23c3d6239814c5471936b618c8fb0c8732ad5da885/certifi-2020.11.8.tar.gz"
    sha256 "f05def092c44fbf25834a51509ef6e631dc19765ab8a57b4e7ab85531f0a9cf4"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "logfury" do
    url "https://files.pythonhosted.org/packages/e2/a0/66a7b78e1800af85e54701490cf8764cc6de6c0725d18b10a6fb13ce4d2d/logfury-0.1.2.tar.gz"
    sha256 "42da58fbbd4e6fdb9e5b6b9098e94c249ba9cebfae125643329c8636768edcd3"
  end

  resource "phx-class-registry" do
    url "https://files.pythonhosted.org/packages/ea/48/b1acdd934f89377fd047401f02c301b938f4962f5af30b8ad7224487c412/phx-class-registry-3.0.5.tar.gz"
    sha256 "f11462ac410a8cda38c2b6a83b51a2390c7d9528baef591cb5b551b11aba2a92"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/da/67/672b422d9daf07365259958912ba533a0ecab839d4084c487a5fe9a5405f/requests-2.24.0.tar.gz"
    sha256 "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/88/e6/13dde83089386c9aa200c4539891948094443d4f6fe85fe95c7806c1f3d5/tqdm-4.51.0.tar.gz"
    sha256 "ef54779f1c09f346b2b5a8e5c61f96fbcb639929e640e59f8cf810794f406432"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/76/d9/bbbafc76b18da706451fa91bc2ebe21c0daf8868ef3c30b869ac7cb7f01d/urllib3-1.25.11.tar.gz"
    sha256 "8d7eaa5a82a1cac232164990f04874c594c9453ec55eef02eab885aa02fc17a2"
  end

  def install
    virtualenv_install_with_resources

    bash_completion.install "contrib/bash_completion/b2" => "b2-tools-completion.bash"
    pkgshare.install (buildpath/"contrib").children
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    cmd = "#{bin}/b2 authorize_account BOGUSACCTID BOGUSAPPKEY 2>&1"
    assert_match "unable to authorize account", shell_output(cmd, 1)
  end
end
