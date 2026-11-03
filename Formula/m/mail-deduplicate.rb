class MailDeduplicate < Formula
  include Language::Python::Virtualenv

  desc "CLI to deduplicate mails from mail boxes"
  homepage "https://kdeldycke.github.io/mail-deduplicate/"
  url "https://files.pythonhosted.org/packages/95/ae/a0cf07f5c0dcc1c6f763fd3a09504c552a86be70a179d4031fac3fef0621/mail_deduplicate-9.5.0.tar.gz"
  sha256 "4a4499b285a3fc272a20f626450aa14fb56a56afc1766ba1baf69e42e42b1a70"
  license "GPL-2.0-or-later"
  head "https://github.com/kdeldycke/mail-deduplicate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "790f0e3b90b245517305b0bd1e9a6c3421f7812783457326814919f6b0f43293"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "43e859bf8c458785f59cdd9d94369455c3f5860e4e9c9bc44c77709f8d9c81c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "42e3c7f956f95109bf02bd833513b1b98a9480344b144ee1fa2ae42ffa1f261f"
    sha256 cellar: :any,                 arm64_linux:       "e1f0f5f731738f7c4024133efb3aa390ae94472933261c8a1cf112ae1a25c234"
    sha256 cellar: :any,                 x86_64_linux:      "f3604377594e8c896c955da2a7cbc1b8eee78e7df3cfbd73af2128e5c2106adf"
  end

  depends_on "rust" => :build # for click_extra > uv_build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.15"

  pypi_packages exclude_packages: "certifi"

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/fb/37/adf8dd2cde958c2d086bdd87fc36b532fd824bf38f10be6348d65da0c8f9/bracex-3.2.tar.gz"
    sha256 "0a3d40bfae4caae4d3bfd0ea715874799fab711c38fd4012cc35343e815405cd"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "click-extra" do
    url "https://files.pythonhosted.org/packages/a6/de/aee972d458aafadb49a7cb17d145df990c318ab1835b37172841fa9aaf4a/click_extra-10.1.1.tar.gz"
    sha256 "c383baa8e2046d151e16158f77440e0dc42e893a73b03040728b5adf676ef075"
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
    url "https://files.pythonhosted.org/packages/bd/07/b7a9162a804bc0f7d03fe84c93e374d3e1c4d828043d5f9b797f7d4e30e0/wcmatch-11.2.tar.gz"
    sha256 "1605bde546fbde4c063628c7d89eda486909fd4337e51d73a873987fbcb2554c"
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
