class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://files.pythonhosted.org/packages/27/2c/1829421e891cddc63cd9317f8e53cc3f94dd649fd0828f268845b10d97c4/b2-3.11.0.tar.gz"
  sha256 "295a1cddf1fa809a4a53545ad9f19694c8458769d7e5e839194f3e8de46c2b9d"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e3b815541d80329268dd197f4e83fd144d868c49dd3c52abe7c99406b6eff5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3210d5924aa0cb120baa746db29daec1c0dc397f52d356b3c1a8c23da539d2dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bec1ac8fadca1e0b0ceb76e838ff9056189f9751f2011de8dd9a97f6b758de07"
    sha256 cellar: :any_skip_relocation, sonoma:         "0281e055803877d6f66a27138b2f8f9c4dc9ae8a5f53ee3b9357e24cce191707"
    sha256 cellar: :any_skip_relocation, ventura:        "c7b9fc6395d8c5f7cf9bf0a144f75e231e81abeb02101680f92387cdd5aa1834"
    sha256 cellar: :any_skip_relocation, monterey:       "b711d1969e0fce154a4ecb49fef26e8424e3cec9becd9627f8da8a358998399c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f56ba34947c2a5a7ec29112392bef155dd0a0d022fac8f15e070fb3e898eebe"
  end

  depends_on "docutils"
  depends_on "python-argcomplete"
  depends_on "python-certifi"
  depends_on "python-setuptools"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "six"

  conflicts_with "boost-build", because: "both install `b2` binaries"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "b2sdk" do
    url "https://files.pythonhosted.org/packages/89/81/ffd3998f719b9ccdeae3604ed85f190ebdee9af8ced388a203f5475024ec/b2sdk-1.24.1.tar.gz"
    sha256 "4e9f518edc9ba824b1075805657ae3c0d2789a6c25f8e593cd5c87776e7425ab"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "logfury" do
    url "https://files.pythonhosted.org/packages/90/f2/24389d99f861dd65753fc5a56e2672339ec1b078da5e2f4b174d0767b132/logfury-1.0.1.tar.gz"
    sha256 "130a5daceab9ad534924252ddf70482aa2c96662b3a3825a7d30981d03b76a26"
  end

  resource "phx-class-registry" do
    url "https://files.pythonhosted.org/packages/79/ce/db26f7f8ed4f4b200f34b8401ecaa9cbb0709f3c3822ae0d29a6019ad2a8/phx-class-registry-4.1.0.tar.gz"
    sha256 "6a7fe8568f9000ad1f90c9a81c5cb65ec20ee3b89b2aaab7a67e14dbb67e11d1"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rst2ansi" do
    url "https://files.pythonhosted.org/packages/3c/19/b29bc04524e7d1dbde13272fbb67e45a8eb24bb6d112cf10c46162b350d7/rst2ansi-0.1.5.tar.gz"
    sha256 "1b17fb9a628d40f57933ad1a3aa952346444be069469508e73e95060da33fe6f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/06/04/e65e7f457ce9a2e338366a3a873ec6994e081cf4f99becb59ab6ce19e4b5/tqdm-4.65.2.tar.gz"
    sha256 "5f7d8b4ac76016ce9d51a7f0ea30d30984888d97c474fdc4a4148abfb5ee76aa"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/1b/2d/f189e5c03c22700c4ce5aece4b51bb73fa8adcfd7848629de0fb78af5f6f/types-python-dateutil-2.8.19.14.tar.gz"
    sha256 "1f4f10ac98bb8b16ade9dbee3518d9ace017821d94b057a425b069f834737f4b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources

    system bin/"b2", "install-autocomplete", "--shell", "bash"
    bash_completion.install "#{Dir.home}/.bash_completion.d/b2"
    pkgshare.install (buildpath/"contrib").children
  end

  test do
    assert_match "-F _python_argcomplete b2",
                 shell_output("bash -c \"source #{bash_completion}/b2 && complete -p b2\"")
    ENV["LC_ALL"] = "en_US.UTF-8"
    cmd = "#{bin}/b2 authorize_account BOGUSACCTID BOGUSAPPKEY 2>&1"
    assert_match "unable to authorize account", shell_output(cmd, 1)
  end
end
