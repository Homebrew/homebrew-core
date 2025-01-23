class Jrnl < Formula
  include Language::Python::Virtualenv

  desc "Command-line note taker"
  homepage "https://jrnl.sh/en/stable/"
  url "https://files.pythonhosted.org/packages/6b/c4/f1738608e5893963516124a76b99aa484e89fe578c41f1219d9ba95b92ae/jrnl-4.2.tar.gz"
  sha256 "68af0347cd7097a6af1b9cf375251df0db67e90b296fd8ef68cdbf12046cc6c7"
  license "GPL-3.0-only"
  head "https://github.com/jrnl-org/jrnl.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "172a60998e3892b52c49d1674444e175001279cd3b826c7c59586c94a6fb3735"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "172a60998e3892b52c49d1674444e175001279cd3b826c7c59586c94a6fb3735"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "172a60998e3892b52c49d1674444e175001279cd3b826c7c59586c94a6fb3735"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1a8d393e49001a46d6f1963ed0bf43b85080cbfcc7e9812cfc764e4bcaa69a8"
    sha256 cellar: :any_skip_relocation, ventura:       "b1a8d393e49001a46d6f1963ed0bf43b85080cbfcc7e9812cfc764e4bcaa69a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "492800f36d819ffdad3abc6e9616f2572d9ce9013e2b445251f57735e6ddc8ff"
  end

  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/df/ad/f3777b81bf0b6e7bc7514a1656d3e637b2e8e15fab2ce3235730b3e7a4e6/jaraco_context-6.0.1.tar.gz"
    sha256 "9bae4ea555cf0b14938dc0aee7c9f32ed303aa20a3b73e7dc80111628792d1b3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/ab/23/9894b3df5d0a6eb44611c36aec777823fc2e07740dabbd0b810e19594013/jaraco_functools-4.1.0.tar.gz"
    sha256 "70f7e0e2ae076498e212562325e805204fc092d7b4c17e0e86c959e249701a9d"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
    sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/f6/24/64447b13df6a0e2797b586dad715766d756c932ce8ace7f67bd384d76ae0/keyring-25.5.0.tar.gz"
    sha256 "4c753b3ec91717fe713c4edd522d625889d8973a349b0e582622f49766de58e6"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/51/78/65922308c4248e0eb08ebcbe67c95d48615cc6f27854b6f2e57143e9178f/more-itertools-10.5.0.tar.gz"
    sha256 "5482bfef7849c25dc3c6dd53a6173ae4795da2a41a80faea6700d9f5846c5da6"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/29/81/4dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9/ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Write the journal
    input = "#{testpath}/journal.txt\nn\nn"
    assert_match "Journal 'default' created", pipe_output("#{bin}/jrnl My journal entry 2>&1", input, 0)
    assert_path_exists testpath/"journal.txt"

    # Read the journal
    assert_match "#{testpath}/journal.txt", shell_output("#{bin}/jrnl --list 2>&1")

    # Encrypt the journal. Needs a TTY to read password.
    require "expect"
    require "pty"
    timeout = 3
    PTY.spawn(bin/"jrnl", "--encrypt") do |r, w, pid|
      refute_nil r.expect("Enter password for journal 'default': ", timeout), "Expected password input"
      w.write "homebrew\r"
      refute_nil r.expect("Enter password again: ", timeout), "Expected password confirmation input"
      w.write "homebrew\r"
      refute_nil r.expect("store the password in your keychain? [Y/n] ", timeout), "Expected keychain input"
      w.write "n\r"
      refute_nil r.expect("Journal encrypted to ", timeout), "Expected result output"
      Process.wait pid
    end

    assert_path_exists testpath/".config/jrnl/jrnl.yaml"
    assert_match "encrypt: true", (testpath/".config/jrnl/jrnl.yaml").read
  end
end
