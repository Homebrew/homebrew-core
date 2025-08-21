class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://files.pythonhosted.org/packages/65/3b/8c65626bff8920e59331f5b2e98748d19797fb5da0ec24b00bd5c3389886/b2-4.4.1.tar.gz"
  sha256 "cc3595b035e2a3fbc1e8d923288d3bdbd07a633e79f303ca602a3932d5865572"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75d00a2a0b996f00059ffa48b473abe94d14615ca3f4fbe9b40226371ec9d767"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75d00a2a0b996f00059ffa48b473abe94d14615ca3f4fbe9b40226371ec9d767"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75d00a2a0b996f00059ffa48b473abe94d14615ca3f4fbe9b40226371ec9d767"
    sha256 cellar: :any_skip_relocation, sonoma:        "c606f9aed257c20f77e46745da7112fb166d90813efa8f96f6bae5b3f43a95d7"
    sha256 cellar: :any_skip_relocation, ventura:       "c606f9aed257c20f77e46745da7112fb166d90813efa8f96f6bae5b3f43a95d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "556c461f3321a18c6eedaaaef81b97e297ea4075742818dfbdde6eda4695f75b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "556c461f3321a18c6eedaaaef81b97e297ea4075742818dfbdde6eda4695f75b"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  conflicts_with "boost-build", because: "both install `b2` binaries"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "b2sdk" do
    url "https://files.pythonhosted.org/packages/3b/ed/41cf8eb982f737b5f591a01446dd78db79269a24bc71142eb74fcf42c039/b2sdk-2.10.0.tar.gz"
    sha256 "be41a07a49ed332129cf3d73262308774187b230862731e473485400a89f8dc3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/ae/ed/aefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9/docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "logfury" do
    url "https://files.pythonhosted.org/packages/90/f2/24389d99f861dd65753fc5a56e2672339ec1b078da5e2f4b174d0767b132/logfury-1.0.1.tar.gz"
    sha256 "130a5daceab9ad534924252ddf70482aa2c96662b3a3825a7d30981d03b76a26"
  end

  resource "phx-class-registry" do
    url "https://files.pythonhosted.org/packages/79/ce/db26f7f8ed4f4b200f34b8401ecaa9cbb0709f3c3822ae0d29a6019ad2a8/phx-class-registry-4.1.0.tar.gz"
    sha256 "6a7fe8568f9000ad1f90c9a81c5cb65ec20ee3b89b2aaab7a67e14dbb67e11d1"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rst2ansi" do
    url "https://files.pythonhosted.org/packages/3c/19/b29bc04524e7d1dbde13272fbb67e45a8eb24bb6d112cf10c46162b350d7/rst2ansi-0.1.5.tar.gz"
    sha256 "1b17fb9a628d40f57933ad1a3aa952346444be069469508e73e95060da33fe6f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/a3/53/07dac71db45fb6b3c71c2fd29a87cada2239eac7ecfb318e6ebc7da00a3b/types_python_dateutil-2.9.0.20250809.tar.gz"
    sha256 "69cbf8d15ef7a75c3801d65d63466e46ac25a0baa678d89d0a137fc31a608cc1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources

    system bin/"b2", "install-autocomplete", "--shell", "bash"
    bash_completion.install "#{Dir.home}/.bash_completion.d/b2"

    # Build an `:all` bottle
    opt_homebrew_files = %W[
      argcomplete-#{resource("argcomplete").version}.dist-info/METADATA
      platformdirs/macos.py
    ]
    opt_homebrew_files.each do |file|
      inreplace libexec/Language::Python.site_packages("python3")/file, "/opt/homebrew", HOMEBREW_PREFIX
    end

    usr_local_files = %W[
      argcomplete/scripts/activate_global_python_argcomplete.py
      platformdirs/unix.py
      platformdirs-#{resource("platformdirs").version}.dist-info/METADATA
    ]
    usr_local_files.each do |file|
      inreplace libexec/Language::Python.site_packages("python3")/file, "/usr/local", HOMEBREW_PREFIX
    end
  end

  test do
    assert_match "-F _python_argcomplete b2",
                 shell_output("bash -c \"source #{bash_completion}/b2 && complete -p b2\"")
    ENV["LC_ALL"] = "en_US.UTF-8"
    output = shell_output("#{bin}/b2 authorize_account BOGUSACCTID BOGUSAPPKEY 2>&1", 1)
    assert_match "unable to authorize account", output
  end
end
