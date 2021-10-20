class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://files.pythonhosted.org/packages/47/c5/e05b32109452201938a9154d726e0df896962b755f33b29cbdc511ef5f85/b2-3.0.3.tar.gz"
  sha256 "6acae18a700d1a54ec4816ed193a0ec5344619209ffb57385569e81377b3a080"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "29ebb7627d56b1e368f39f1996136a344a1390e03ee7f259a809374ca75e823e"
    sha256 cellar: :any_skip_relocation, big_sur:       "c8a0512ecac3fb5ba59f29d7cfa1b73dbb099353b505a708fa9ac824888f1f4f"
    sha256 cellar: :any_skip_relocation, catalina:      "2cb408b13597fd2df011e69518020539363733031b6195ea44fdbfa4530d5927"
    sha256 cellar: :any_skip_relocation, mojave:        "ff77471b683a7ba34d6e1e044cf4a50bdc0e882a872fa74e52ba03ac51820ca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f59c61c7e3d4dec4af4e644bc80ae4e6f78dfa7aa2d570130e93c72db873cbbf"
  end

  depends_on "python@3.9"
  depends_on "six"

  conflicts_with "boost-build", because: "both install `b2` binaries"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/ec/74/1cf2d9912921cebdba3fa954949206c8aa159c9cc803b88140fb227f8a0e/arrow-0.17.0.tar.gz"
    sha256 "ff08d10cda1d36c68657d6ad20d74fbea493d980f8b2d45344e00d6ed2bf6ed4"
  end

  resource "b2sdk" do
    url "https://files.pythonhosted.org/packages/bb/5c/6622416dd20552f2bfd0f3776c87281074f19e32f807dcd2bceb72d8cd4b/b2sdk-1.12.0.tar.gz"
    sha256 "3ec2264ae2b421563d130a4b2a53f96454ba03b8f68893ad520fc651c413251d"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/eb/7f/a6c278746ddbd7094b019b08d1b2187101b1f596f35f81dc27f57d8fcf7c/charset-normalizer-2.0.6.tar.gz"
    sha256 "5ec46d183433dcbd0ab716f2d7f29d8dee50505b3fdb40c6b985c7c4f5a3591f"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/2f/e0/3d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219d/docutils-0.16.tar.gz"
    sha256 "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc"
  end

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/38/4c4d00ddfa48abe616d7e572e02a04273603db446975ab46bbcd36552005/idna-3.2.tar.gz"
    sha256 "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3"
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
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "rst2ansi" do
    url "https://files.pythonhosted.org/packages/3c/19/b29bc04524e7d1dbde13272fbb67e45a8eb24bb6d112cf10c46162b350d7/rst2ansi-0.1.5.tar.gz"
    sha256 "1b17fb9a628d40f57933ad1a3aa952346444be069469508e73e95060da33fe6f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/e3/c1/b3e42d5b659ca598508e2a9ef315d5eef0a970f874ef9d3b38d4578765bd/tqdm-4.62.3.tar.gz"
    sha256 "d359de7217506c9851b7869f3708d8ee53ed70a1b8edbba4dbcb47442592920d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
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
