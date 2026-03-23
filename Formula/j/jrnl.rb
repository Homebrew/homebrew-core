class Jrnl < Formula
  include Language::Python::Virtualenv

  desc "Command-line note taker"
  homepage "https://jrnl.sh/en/stable/"
  url "https://files.pythonhosted.org/packages/06/50/c1925fbf8472667b6cee6c211645fdc82a550d120ebe50536645252e4e64/jrnl-4.3.tar.gz"
  sha256 "19ee865bf289b12bf412723874bd5876e25c2b6fbef7a226ea975fa3fcf0920f"
  license "GPL-3.0-only"
  head "https://github.com/jrnl-org/jrnl.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f6243f3ad0ca6d67decd79f6d1259050dff6c3a29fa1b701663704185a9f0d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5dd0c2b7573144dba8f37a77b45d31d8ce96d2e7c0e67ad65ee73a2ac331957"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb03a74a09b2047ae74c36acab7c8a4005075be0624a7e4c56c6f325b84fa656"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f79d0928c0ba26a0d9fbbbd4c8df80d5d20d2dec48d256956d9e6fc46d4c807"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35fc1e8658ba3716b4623a30f1af22f2cd3e95aa2d24cd27f27928d79ad358ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20fc1a734e0194dd3b6091528db1b747ba4b47ba4ea2df74f1106f48b9661dc7"
  end

  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "cryptography",
                extra_packages:   %w[jeepney secretstorage]

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/cb/9c/a788f5bb29c61e456b8ee52ce76dbdd32fd72cd73dd67bc95f42c7a8d13c/jaraco_context-6.1.0.tar.gz"
    sha256 "129a341b0a85a7db7879e22acd66902fda67882db771754574338898b2d5d86f"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/0f/27/056e0638a86749374d6f57d0b0db39f29509cce9313cf91bdc0ac4d91084/jaraco_functools-4.4.0.tar.gz"
    sha256 "da21933b0417b89515562656547a77b4931f98176eb173644c0d35032a33d6bb"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
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
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/ea/97/60fda20e2fb54b83a61ae14648b0817c8f5d84a3821e40bfbdae1437026a/ruamel_yaml_clib-0.2.15.tar.gz"
    sha256 "46e4cc8c43ef6a94885f72512094e482114a8a706d3c555a34ed4b0d20200600"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/8b/2e/c14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5/tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  def install
    without = %w[jeepney secretstorage] unless OS.linux?
    virtualenv_install_with_resources(without:)
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
    timeout = 5
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
