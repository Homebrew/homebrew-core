class MailDeduplicate < Formula
  include Language::Python::Virtualenv

  desc "CLI to deduplicate mails from mail boxes"
  homepage "https://kdeldycke.github.io/mail-deduplicate/"
  url "https://files.pythonhosted.org/packages/f9/c9/a80d901668896b00d20aab80c91c02cafdd203134245acc8c74099b4a1c7/mail_deduplicate-9.3.0.tar.gz"
  sha256 "91da1ef5da2d22f125afaeea36a59aa8301707a3843361cce63081e416ef486e"
  license "GPL-2.0-or-later"
  head "https://github.com/kdeldycke/mail-deduplicate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9446e03ee71dee544cf6b5641855f559732700e0f5973d931548700782c37f9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9446e03ee71dee544cf6b5641855f559732700e0f5973d931548700782c37f9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9446e03ee71dee544cf6b5641855f559732700e0f5973d931548700782c37f9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "638ce0ee0d541e1f21379074628e7dedd918a89c8e9f71b7d583f7b1442236dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "638ce0ee0d541e1f21379074628e7dedd918a89c8e9f71b7d583f7b1442236dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "638ce0ee0d541e1f21379074628e7dedd918a89c8e9f71b7d583f7b1442236dc"
  end

  depends_on "rust" => :build # for click_extra > uv_build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/47/99/12bace94ae2ba961bdc46d49277ff15d38dba074bc3987b0c0b4355a37a7/boltons-26.1.0.tar.gz"
    sha256 "5764468aba493b15995ed17f46a16789023f123ca2a62d491a9ce825c1cbe26c"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/ac/01/5f394b8bcd6e5b92f73130990960423bbb19711f906bd9fe9ea5557c667c/bracex-3.0.1.tar.gz"
    sha256 "4e38e32392e4a4780fe15d644bfc7c8514057cfc3861e060b11814ce829c25e4"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "click-extra" do
    url "https://files.pythonhosted.org/packages/f6/f2/ab33d5d978f4ceb1b52eb3e4ee0538aa197768913d411380a7b318e45e91/click_extra-8.8.1.tar.gz"
    sha256 "fc67535bbc186ac608b04f1da3dd1c442903567f08a12f484af89a894653f796"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/42/ca/cf02e965cfeb70d65c61fd3abb8022aaf5111a0de71b3c73a6ec2113aa25/cloup-3.1.0.tar.gz"
    sha256 "637c1e628fe98f3f20a5e44da591a72b42bf54d7d4527190bf39ed5f64af7585"
  end

  resource "deepmerge" do
    url "https://files.pythonhosted.org/packages/2a/78/6e9e20106224083cfb817d2d3c26e80e72258d617b616721a169b87081e0/deepmerge-2.1.0.tar.gz"
    sha256 "07ca7a7b8935df596c512fa8161877c0487ac61f691c07766e7d71d2b23bdd2f"
  end

  resource "extra-platforms" do
    url "https://files.pythonhosted.org/packages/d0/20/3d7ba1bd9cd9235eda78a143adcb2a710c6117f5b3f500237bc2f240808c/extra_platforms-13.6.0.tar.gz"
    sha256 "92b5800c0ca9767820ae2cf3d48b7037432c1360055ed1804bc43a8269a2a090"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/36/0a/062135c9a98dac804265073cc3afdbec5ae1aa37980bb354f461bafe81b4/platformdirs-4.11.1.tar.gz"
    sha256 "bb1af68078f25e2f3e111e2d43b8d536df41b73c8a684b40bb018223b66fae27"
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
    url "https://files.pythonhosted.org/packages/16/25/1da725838132221e33568973da484ff43813662ccc06ebf7f6e3abddfcd5/wcmatch-11.0.tar.gz"
    sha256 "55d95c2447789712774b198ceec72939e88b5618f1f8f0a9b605bf7740b63b96"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/34/74/c6428f875774288bec1396f5bfcbc2d925700a4dad61727fd5f2b12f249d/wcwidth-0.8.2.tar.gz"
    sha256 "91fbef97204b96a3d4d421609b80340b760cf33e26da123ff243d76b1fda8dda"
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
