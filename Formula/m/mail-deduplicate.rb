class MailDeduplicate < Formula
  include Language::Python::Virtualenv

  desc "CLI to deduplicate mails from mail boxes"
  homepage "https://kdeldycke.github.io/mail-deduplicate/"
  url "https://files.pythonhosted.org/packages/0a/30/7221997bf2d4dae663c1492b9d346d931de01ab6710b24eb21fbd6bc0f16/mail_deduplicate-9.7.1.tar.gz"
  sha256 "e99120e3c505a06bbc2f963a515399b34515ae2eaa48f187c968067ed89ca45d"
  license "GPL-2.0-or-later"
  head "https://github.com/kdeldycke/mail-deduplicate.git", branch: "main"

  bottle do
    manifest_sha256 "28ea07f4f9e4a2716cc703594deba70a8c1a73aa574fb2ad10a8a39320f47704"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a49c1ad2c9aba0d3cdbb2a6c9f6a69106c011a8849ac073995994ac3b5a0ec1b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "df4a19c4bc69566e9603fd12f4dafe3e051f239ad517849a93f6cd4c131fa732"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f30f3105a394f3692cf7d68dff5d5802899581a3d222990e91c572dccc2a4d11"
    sha256 cellar: :any,                 arm64_linux:       "6955fc158574c3d7c6c759c410163279788db7e67bdae5d55144dc9b79f8d817"
    sha256 cellar: :any,                 x86_64_linux:      "6e69963fcd9cc7cf0008c8c08c6031e03297f0fd701741b03a9038d8a3c515c6"
  end

  depends_on "rust" => :build # for click_extra > uv_build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.15"

  pypi_packages exclude_packages: "certifi"

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/42/39/9ae971118d77b86cc3f03ab5a467ddb58de352d8ef29830c81531d22010c/bracex-3.2.3.tar.gz"
    sha256 "8fbf92b4db3c31de999145e22a47d4ffdbefb983a98583c3272bd7d570f9a343"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "click-extra" do
    url "https://files.pythonhosted.org/packages/de/5e/db9986517ce10c38bb224b24f18f64bf6061effc295a2c28fc1569843bcd/click_extra-10.2.0.tar.gz"
    sha256 "499b8ad73f9fa9182f799fbb14ebbc7e61a6dde9c2977954173fdcef4b32994e"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/05/e2/d41446c6195eff0db3b671ddb202e39f42f9ea7c0dd15cd43fbf5cf0d7f7/cloup-4.0.0.tar.gz"
    sha256 "83b0870ee863bcc85129e40e1b208bcfdebe4cd2142e9ce1d0daf7d276cab038"
  end

  resource "extra-platforms" do
    url "https://files.pythonhosted.org/packages/99/37/5c2fde6d7c6036fd53144e63b37d8632314f791f3d681d3fcf0456d06292/extra_platforms-14.0.1.tar.gz"
    sha256 "c58c5cb5dab87ee907b977be403ed2fa2e923bdc27bd39c76c6b60c99ea0700c"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tomlrt" do
    url "https://files.pythonhosted.org/packages/72/76/d79f58d95f40b0a2fe66a34b770f9dbbba808457627d03b21af3a98f3e67/tomlrt-2.3.3.tar.gz"
    sha256 "36782cf6821cd1962f34a548c2023984e4a60e32f286c36d7dc1430b77ac59ba"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/db/c5/fb0e01e995d104af32ce83a4ada70476d647c116dc8897887949c9886204/wcmatch-12.0.3.tar.gz"
    sha256 "ccf83affafadc4286ffb335bc827ca2bffb0547fa5d5587600b585151bce4359"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/ea/01/e5ac23733628a6bbb91913a765fcf55ee8070d8d991bc88fdaaf805052c7/wcwidth-0.9.4.tar.gz"
    sha256 "fd8d57d3cdfe570e3265c8fab1885c24e34ef40889c0759c0c304a19e9835954"
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
    assert_match "DRY RUN: would have Copied 2/2 mails", output
  end
end
