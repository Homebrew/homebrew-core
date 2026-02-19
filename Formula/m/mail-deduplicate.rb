class MailDeduplicate < Formula
  include Language::Python::Virtualenv

  desc "CLI to deduplicate mails from mail boxes"
  homepage "https://kdeldycke.github.io/mail-deduplicate/"
  url "https://files.pythonhosted.org/packages/0c/0c/0e83bc1a549394b6c372caa8e6e5859020d23f470362d02276f1d2d56645/mail_deduplicate-8.1.2.tar.gz"
  sha256 "30ed948490f35f47da27829f239c20068a936010d78e198da44b69f1d65c3d1e"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/kdeldycke/mail-deduplicate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "03bcd3be40f5122e5bf174e5edd3aa219bfb410b57e86fd9f1108fa2150e86dc"
  end

  depends_on "rust" => :build # for click_extra > uv_build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/b9/33/032cdc44182491aa708d06a68b62434140d8c50820a087fac7af37703357/arrow-1.4.0.tar.gz"
    sha256 "ed0cc050e98001b8779e84d461b0098c4ac597e88704a655582b21d116e526d7"
  end

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/63/54/71a94d8e02da9a865587fb3fff100cb0fc7aa9f4d5ed9ed3a591216ddcc7/boltons-25.0.0.tar.gz"
    sha256 "e110fbdc30b7b9868cb604e3f71d4722dd8f4dcb4a5ddd06028ba8f1ab0b5ace"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/63/9a/fec38644694abfaaeca2798b58e276a8e61de49e2e37494ace423395febc/bracex-2.6.tar.gz"
    sha256 "98f1347cd77e22ee8d967a30ad4e310b233f7754dbf31ff3fceb76145ba47dc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "click-extra" do
    url "https://files.pythonhosted.org/packages/50/2a/79e85d7683fd97037326dbdad60524c075ef01dad2adad0a6d6fa40c41a4/click_extra-7.4.0.tar.gz"
    sha256 "869cd811074a4c5049fb241087e55242bf36ee328133ae932f37730833d9b9d9"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/46/cf/09a31f0f51b5c8ef2343baf37c35a5feb4f6dfdcbd0592a014baf837f2e4/cloup-3.0.8.tar.gz"
    sha256 "f91c080a725196ddf74feabd6250266f466e97fc16dfe21a762cf6bc6beb3ecb"
  end

  resource "deepmerge" do
    url "https://files.pythonhosted.org/packages/a8/3a/b0ba594708f1ad0bc735884b3ad854d3ca3bdc1d741e56e40bbda6263499/deepmerge-2.0.tar.gz"
    sha256 "5c3d86081fbebd04dd5de03626a0607b809a98fb6ccba5770b62466fe940ff20"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "extra-platforms" do
    url "https://files.pythonhosted.org/packages/fb/df/73e313d4ecca7b703b6f369d9ed0c2c0d4d8a149e1c675e9915f8426a513/extra_platforms-6.0.0.tar.gz"
    sha256 "ff0d392e390d2447183af4b300dd4569d2dbf760adf1e30c2b0cefb30ee58488"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/5e/a7/c202b344c5ca7daf398f3b8a477eeb205cf3b6f32e7ec3a6bac0629ca975/tzdata-2025.3.tar.gz"
    sha256 "de39c2ca5dc7b0344f2eba86f49d614019d29f060fc4ebc8a417896a620b56a7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/79/3e/c0bdc27cf06f4e47680bd5803a07cb3dfd17de84cde92dd217dcb9e05253/wcmatch-10.1.tar.gz"
    sha256 "f11f94208c8c8484a16f4f48638a85d771d9513f4ab3f37595978801cb9465af"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
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
