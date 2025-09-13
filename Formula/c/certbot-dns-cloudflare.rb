class CertbotDnsCloudflare < Formula
  include Language::Python::Virtualenv

  desc "Cloudflare DNS Authenticator plugin for Certbot"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/a9/96/6afc38a2f491b779f59cc547cd797dc2b6e0a2bca494a202732dc0029d20/certbot_dns_cloudflare-5.0.0.tar.gz"
  sha256 "84c01b06b2b0055f1b551eb3c0bc82c0a275063207cf9ea7ddc1b67129c728a4"
  license "Apache-2.0"

  depends_on "certbot"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "cloudflare" do
    url "https://files.pythonhosted.org/packages/9b/8f/d3a435435c42d4b05ce2274432265c5890f91f6047e6dab52e50c811a4ea/cloudflare-2.19.4.tar.gz"
    sha256 "3b6000a01a237c23bccfdf6d20256ea5111ec74a826ae9e74f9f0e5bb5b2383f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resources
    venv.pip_install_and_link buildpath

    pth = prefix/Language::Python.site_packages("python3.13")/"homebrew-certbot-dns-cloudflare.pth"
    pth.write venv.site_packages
  end

  test do
    # Verify the plugin is available to certbot
    assert_match "dns-cloudflare",
      shell_output("#{Formula["certbot"].bin}/certbot plugins")
  end
end
