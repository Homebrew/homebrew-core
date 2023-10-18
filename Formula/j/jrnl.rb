class Jrnl < Formula
  include Language::Python::Virtualenv

  desc "Command-line note taker"
  homepage "https://jrnl.sh/en/stable/"
  url "https://files.pythonhosted.org/packages/04/59/c15befa8f1a6ff159af29d86c1abc50135e4f8768afe5a1621930e21a0d8/jrnl-4.0.1.tar.gz"
  sha256 "f3b17c4b040af44fde053ae501832eb313f2373d1b3b1a82564a8214d223ede8"
  license "GPL-3.0-only"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b133157df1c07005abc8be367a28fd5c70bc6da77246a481275fbd45e3cb37d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e8023c19c8d51de9420a1405942d802bebfed64d402251de139ee4256187976"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "667dd5a5f42f90f7e80588a55add0880d6d4aebf7936398ac15520843f3dba6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2d08dbfd2571715f489833af6de0afbf0dc481fe206d514b78620de1ae0d8c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a1193de3baede8bbff9472ab95ad37bf7b6a606eb4a09bf092cf4596a39f0fa"
    sha256 cellar: :any_skip_relocation, ventura:        "b87332491a22d044b9a7ce81498cea8f195509cd74c125c6a5ea31180a93b426"
    sha256 cellar: :any_skip_relocation, monterey:       "8640a3b9d5449d449f5a675cd3874aa50b3f93247b1127a1ade0e73220b1af36"
    sha256 cellar: :any_skip_relocation, big_sur:        "58ec0e20fa23d1ca8a66c39c525866282707b307ffbfcc7dd9e37844c6b2b8b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0e726aaefed69288f3cf9157f776a2af172d14a7d0f1643420a55184114462e"
  end

  depends_on "cffi"
  depends_on "keyring"
  depends_on "pygments"
  depends_on "python-cryptography"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "expect" => :test

  resource "ansiwrap" do
    url "https://files.pythonhosted.org/packages/7c/45/2616341cfcace37d4619d5106a85fcc24f2170d1a161bc5f7fdb81772fbc/ansiwrap-0.8.4.zip"
    sha256 "ca0c740734cde59bf919f8ff2c386f74f9a369818cdc60efe94893d01ea8d9b7"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ad/1a/94fe086875350afbd61795c3805e38ef085af466a695db605bcdd34b4c9c/rich-13.5.2.tar.gz"
    sha256 "fb9d6c0a0f643c99eed3875b5377a184132ba9be4d61516a55273d3554d75a39"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/63/dd/b4719a290e49015536bd0ab06ab13e3b468d8697bec6c2f668ac48b05661/ruamel.yaml-0.17.32.tar.gz"
    sha256 "ec939063761914e14542972a5cba6d33c23b0859ab6342f61cf070cfc600efc2"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/d5/31/a3e6411947eb7a4f1c669f887e9e47d61a68f9d117f10c3c620296694a0b/ruamel.yaml.clib-0.2.7.tar.gz"
    sha256 "1f08fd5a2bea9c4180db71678e850b995d2a5f4537be0e94557668cf0f5f9497"
  end

  resource "textwrap3" do
    url "https://files.pythonhosted.org/packages/4d/02/cef645d4558411b51700e3f56cefd88f05f05ec1b8fa39a3142963f5fcd2/textwrap3-0.9.2.zip"
    sha256 "5008eeebdb236f6303dcd68f18b856d355f6197511d952ba74bc75e40e0c3414"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/ee/f5/3e644f08771b242f7460438cdc0aaad4d1484c1f060f1e52f4738d342983/tzlocal-5.0.1.tar.gz"
    sha256 "46eb99ad4bdb71f3f72b7d24f4267753e240944ecfc16f25d2719ba89827a803"
  end

  def install
    virtualenv_install_with_resources

    # we depend on keyring, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    keyring = Formula["keyring"].opt_libexec
    (libexec/site_packages/"homebrew-keyring.pth").write keyring/site_packages
  end

  test do
    (testpath/"tests.sh").write <<~EOS
      #!/usr/bin/env expect

      set timeout 3
      match_max 100000

      spawn "#{bin}/jrnl" --encrypt
      expect -exact "Enter password for journal 'default': "
      sleep 0.5
      send -- "homebrew\\r"
      expect -exact "Enter password again: "
      sleep 0.5
      send -- "homebrew\\r"
      expect -exact "Do you want to store the password in your keychain? \\[Y/n\\] "
      send -- "n\\r"
      expect -re "Journal encrypted to .*"
      expect eof
    EOS

    # Write the journal
    input = "#{testpath}/journal.txt\nn\nn"
    assert_match "Journal 'default' created", pipe_output("#{bin}/jrnl My journal entry 2>&1", input, 0)
    assert_predicate testpath/"journal.txt", :exist?

    # Read the journal
    assert_match "#{testpath}/journal.txt", shell_output("#{bin}/jrnl --list 2>&1")

    # Encrypt the journal. Needs a TTY to read password.
    system "expect", "./tests.sh"
    assert_predicate testpath/".config/jrnl/jrnl.yaml", :exist?
    assert_match "encrypt: true", (testpath/".config/jrnl/jrnl.yaml").read
  end
end
