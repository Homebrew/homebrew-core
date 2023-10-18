class Mvt < Formula
  include Language::Python::Virtualenv

  desc "Mobile device forensic toolkit"
  homepage "https://docs.mvt.re/en/latest/"
  url "https://files.pythonhosted.org/packages/50/50/e405c534c489801620762c1358ba40ef11bee3bb35d6cdf1245189d3f3c9/mvt-2.4.2.tar.gz"
  sha256 "b97e4f4732d61da4a2b69b7029c37e4d5442353a3e109855fe77c782e9c4cc7f"
  license :cannot_represent # Adaptation of MPL-2.0
  head "https://github.com/mvt-project/mvt.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a68dadea290107ad3594294594f2f69ac100dcbc794a5df55415b4ea64b5a59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a8ffbf9c90edf8dff047244c35362eb4bd71d25ea5faf9f8d0aa37ca159d85b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11cb3cac207dff5b8604da271485c7267541bd1b9f11f2039a81412213ab904c"
    sha256 cellar: :any_skip_relocation, sonoma:         "20a2bce5d582e38cfaf6058804ae9571d46c7dac90090d99e22fa85c0bb3253a"
    sha256 cellar: :any_skip_relocation, ventura:        "d77e36762f51a7432dcbb240faa2a2091e0d9fc396c9bb9240ceed4a06745bf8"
    sha256 cellar: :any_skip_relocation, monterey:       "cfdaae2c42177c37b9b8bdb60fe73b7724f2c4c57e1ccf3d876e6d3db9e4d1c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49a2dda86c11cb4ada01551a6849b917e0778e67c1c035c25f370872a517c7b2"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-cryptography"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "adb-shell" do
    url "https://files.pythonhosted.org/packages/8f/73/d246034db6f3e374dad9a35ee3f61345a6b239d4febd2a41ab69df9936fe/adb_shell-0.4.4.tar.gz"
    sha256 "04c305f30a2ca25d5c54b3cd6ce9bb64c36e5f07967b23b3fb6aaecc851b90b6"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "libusb1" do
    url "https://files.pythonhosted.org/packages/f4/83/59bf75e74e0c4859ea63eae0c7da660c1dcb78b31667d4a5f735d52f5974/libusb1-3.0.0.tar.gz"
    sha256 "5792a9defee40f15d330a40d9b1800545c32e47ba7fc66b6f28f133c9fcc8538"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "nskeyedunarchiver" do
    url "https://files.pythonhosted.org/packages/e8/d9/227a00737de97609b0b2d161905f03bb8e246df0498ec5735b83166eef8f/NSKeyedUnArchiver-1.5.tar.gz"
    sha256 "eeda0480021817336e0ffeaca80377c1a8f08ecc5fc06be483b48c44bad414f4"
  end

  resource "pyahocorasick" do
    url "https://files.pythonhosted.org/packages/28/0a/9cf574f8aed5a38f945944481ea297953dfed065aacdd045c9a0c5df0458/pyahocorasick-2.0.0.tar.gz"
    sha256 "2985cac6d99c0e9165617fe154b4db0b50c4c2819791c2ad5f0aac0c6a6e58c5"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/1a/72/acc37a491b95849b51a2cced64df62aaff6a5c82d26aca10bc99dbda025b/pycryptodome-3.19.0.tar.gz"
    sha256 "bc35d463222cdb4dbebd35e0784155c81e161b9284e567e7e933d722e533331e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b1/0e/e5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3/rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/79/79/3ccb95bb4154952532f280f7a41979fbfb0fbbaee4d609810ecb01650afa/simplejson-3.19.2.tar.gz"
    sha256 "9eb442a2442ce417801c912df68e1f6ccfcd41577ae7274953ab3ad24ef7d82c"
  end

  resource "tld" do
    url "https://files.pythonhosted.org/packages/19/2b/678082222bc1d2823ea8384c6806085b85226ff73885c703fe0c7143ef64/tld-0.13.tar.gz"
    sha256 "93dde5e1c04bdf1844976eae440706379d21f4ab235b73c05d7483e074fb5629"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  # This resource depends on `nskeyedunarchiver`, so we place it last
  resource "iosbackup" do
    url "https://files.pythonhosted.org/packages/db/b8/4cd52322deceb942b9e18b127d45d112c2f7a3ec7821ab528659d4f04275/iOSbackup-0.9.925.tar.gz"
    sha256 "33545a9249e5b3faaadf1ee782fe6bdfcdb70fae0defba1acee336a65f93d1ca"
  end

  def install
    virtualenv_install_with_resources

    %w[mvt-android mvt-ios].each do |script|
      generate_completions_from_executable(bin/script, shells: [:fish, :zsh], shell_parameter_format: :click)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mvt-android version")
    assert_match version.to_s, shell_output("#{bin}/mvt-ios version")

    outputandroid = shell_output("#{bin}/mvt-android download-iocs")
    outputios = shell_output("#{bin}/mvt-ios download-iocs")

    assert_match "[mvt.common.updates] Downloaded indicators", outputandroid
    assert_match "[mvt.common.updates] Downloaded indicators", outputios
  end
end
