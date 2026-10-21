class MailDeduplicate < Formula
  include Language::Python::Virtualenv

  desc "CLI to deduplicate mails from mail boxes"
  homepage "https://kdeldycke.github.io/mail-deduplicate/"
  url "https://files.pythonhosted.org/packages/59/4b/0d3d5ee73a939c242551aeb4ef6fab754646f697d481594bd69e0433e819/mail_deduplicate-9.3.2.tar.gz"
  sha256 "f362531b11e99cb5a51c7806b960e22bff7607dace1a713511baf9653af966e5"
  license "GPL-2.0-or-later"
  head "https://github.com/kdeldycke/mail-deduplicate.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7a152c211956d9e15c483c431320ca61d675771bc43778aa9841d3bba441c937"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "262e1f5307e6128efa3e30094f9d2938edf17034a218069808df1fec62949542"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf800b8b3f9b1883003d953b25fab99db722ce1b15508ae11005fbecb3fb8649"
    sha256 cellar: :any,                 arm64_linux:       "5864c8d8f7ab5aea704311558b720e6a3f5af4abc9d5d3c3ba1017d0fc59f103"
    sha256 cellar: :any,                 x86_64_linux:      "8734d5b0a6272139378436548930bea8afe71bea9fee415856ba24d75e1b1807"
  end

  depends_on "rust" => :build # for click_extra > uv_build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.15"

  pypi_packages exclude_packages: "certifi"

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/71/56/14c4a4931910a81ddeccfbe227925ea738e3c445d3e2af960f0bcbba1616/boltons-26.2.0.tar.gz"
    sha256 "d39cfd15c1a1c3bd4d705c82252fa9edb8e4f5e8cc039f8e39afac7b1b47e92c"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/ac/01/5f394b8bcd6e5b92f73130990960423bbb19711f906bd9fe9ea5557c667c/bracex-3.0.1.tar.gz"
    sha256 "4e38e32392e4a4780fe15d644bfc7c8514057cfc3861e060b11814ce829c25e4"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "click-extra" do
    url "https://files.pythonhosted.org/packages/13/20/e2d60c90277a668b10a00f7a74cd52a87ab0c85afd5b8975cc582601eafc/click_extra-9.4.1.tar.gz"
    sha256 "065df41b1c8f6601bd9e550d79ac34a73ba40bfc84cfdb320cdcfe066c40a6d1"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/05/e2/d41446c6195eff0db3b671ddb202e39f42f9ea7c0dd15cd43fbf5cf0d7f7/cloup-4.0.0.tar.gz"
    sha256 "83b0870ee863bcc85129e40e1b208bcfdebe4cd2142e9ce1d0daf7d276cab038"
  end

  resource "deepmerge" do
    url "https://files.pythonhosted.org/packages/38/6e/5cb3548b4d3112fea529375e55e6f3cdc52b8054e3a66f203b1f888ba885/deepmerge-3.0.1.tar.gz"
    sha256 "35b39a4cb92cf328d6eca61cbbf65f68a37c2ceb3085f0f853cbb2e52a59fc23"
  end

  resource "extra-platforms" do
    url "https://files.pythonhosted.org/packages/ee/e9/805ffa0a5d7bbb2eee2297a2fe1c22e41b2900daa2f1144d335e827e2a1b/extra_platforms-13.11.0.tar.gz"
    sha256 "79bd4a79df48a873c6cd46e2c7318a7604f3d07c7a14b405b22f63b1368eef11"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/80/a8/66d45abadff219e36e2a824181b8f6a67e7ed4572934d6252c71c29d5731/platformdirs-4.13.0.tar.gz"
    sha256 "1aa0b0d3f224c1f07c295121e312a5a24a180d6ae5a8425ea1784b3e3863e9c0"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/78/cd/0e028d8b7d906d51acdac537334fbe85f8284f2a8147d48bc9403af77a0d/wcmatch-11.1.tar.gz"
    sha256 "f2b6f0fad6f5e2571498723fcb3c8facdd0fba0dcc139f31d32f592eb648153e"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/f0/b4/7830542634bb2d3e62aa3b586a72d5b3b6c91c3168929e7000ef3fed041d/wcwidth-0.9.2.tar.gz"
    sha256 "ae0ef90b90f6af38b54f1fe6d58662ec33b3cb4b8391958a62416d654231727b"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"mdedup", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdedup --version")

    (testpath/"test_mail1.eml").write <<~EOS
      From: sender1@example.com
      To: recipient@example.com
      Subject: Test Email 1

      This is a test email 1.
    EOS

    (testpath/"test_mail2.eml").write <<~EOS
      From: sender2@example.com
      To: recipient@example.com
      Subject: Test Email 2

      This is a test email 2.
    EOS

    # Run mail-deduplicate to check functionality
    output = shell_output("#{bin}/mdedup --dry-run " \
                          "--export=#{testpath}/deduped_mail.mbox test_mail1.eml test_mail2.eml 2>&1")
    assert_match "No mail selected to perform action on", output
  end
end
