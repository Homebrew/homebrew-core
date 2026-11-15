class MailDeduplicate < Formula
  include Language::Python::Virtualenv

  desc "CLI to deduplicate mails from mail boxes"
  homepage "https://kdeldycke.github.io/mail-deduplicate/"
  url "https://files.pythonhosted.org/packages/6b/92/1ca219adac449af52e072853092d8e315da97c102ad77651a8c56877caac/mail_deduplicate-9.6.0.tar.gz"
  sha256 "9bca8c396d62c7adf61e0f3c3fd12b3818c52df6f06aa9c86262a0e99c762116"
  license "GPL-2.0-or-later"
  head "https://github.com/kdeldycke/mail-deduplicate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eab52fa01e56b05569f1a6a501a0a9a47734eab988c679ad25fa06dd0ae3d419"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "08cb6600c140138bdc8b83f0486b01b3f67f0435e7908752ac0f20d35425f56f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d0784afdec16498f46e7aa1f6b824b359f26efaf4731772a8db4de9ccb6147a4"
    sha256 cellar: :any,                 arm64_linux:       "baa7557bce3c0722f070c4f30ddd46a74e470132d4e28cc73aa9ef8a6f8ecbf6"
    sha256 cellar: :any,                 x86_64_linux:      "0de3a8bc80b2abb3efcd184ced949a4958b1ce94753b010c276ac1abfe3dc8b8"
  end

  depends_on "rust" => :build # for click_extra > uv_build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.15"

  pypi_packages exclude_packages: "certifi"

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/4d/fc/137095eb2f24ccf0b4db196abd9f5cfe74398a834af51d4bc4876e0beaf0/bracex-3.2.1.tar.gz"
    sha256 "07a9b2100ceecc0c24afa1a1714bf8d4a6abb43d592939455f662b682ac9baa4"
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
    url "https://files.pythonhosted.org/packages/60/81/eb96ce41e8def4ff3b02cec7d1d92e3682597de5064d8687ac88d1734f18/wcmatch-12.0.tar.gz"
    sha256 "80ebfdf510d5fef580c4fc662b9eba76b331cff20d7913fc6e722edcb199cbe6"
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
    assert_match "No mail selected to perform action on", output
  end
end
