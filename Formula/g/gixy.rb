class Gixy < Formula
  include Language::Python::Virtualenv

  desc "NGINX configuration static analyzer focused on security"
  homepage "https://gixy.getpagespeed.com/"
  url "https://files.pythonhosted.org/packages/c9/f8/051fa50e74a612dd7b52b3fa450f943120968648ad9068bb7e30261a755e/gixy_ng-0.2.55.tar.gz"
  sha256 "5f3cb7e09e9c37f4d0d15130ca0c797e5a589acfefba92440bc5f187643ef3c2"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5f45796934cb1e2b5f11535789e4931692062d874f62b311a3fb63673137ffd2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a62ab18602510f09b979e901e49e9bd39b2ccd801d61c79c9e535144dbec09af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ad1abaccf18b9a88176d15f72e619729c36bf09eb72a67253a75a15e387445c6"
    sha256 cellar: :any,                 arm64_linux:       "e9d4bc230e0f97ce194d9333c88e81e4ad33a3d117102bdc928d343f2f75a0d7"
    sha256 cellar: :any,                 x86_64_linux:      "c661fe3bd53f9f83a4b7b3fc504c381b76d6a0aa59349253936d95fc1e9b2594"
  end

  depends_on "python@3.15"

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/5d/ed/33c0ba7f0b5be384ff8a2101ce77728f219e816b2104819f1651477e1ad5/configargparse-1.8.0.tar.gz"
    sha256 "22a417f4d7b00149f0af82ef7c491f8ecc4b1d5454633fd319b386f5eb806f92"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "ngxparse" do
    url "https://files.pythonhosted.org/packages/35/2e/b6247bc5ebaeb5a70c81c865451c140fa30d8c3a6e81598a659c0497e525/ngxparse-0.5.16.tar.gz"
    sha256 "33746d1693d93903ab0c2b37ba16b8a4743a2767b1959dc125a2417d253b7e3b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gixy --version")

    (testpath/"vuln.conf").write <<~NGINX
      http {
        server {
          listen 80;
          location / {
            return 301 http://$host$uri;
          }
        }
      }
    NGINX
    # Gixy exits non-zero when issues are found, hence the trailing `:1`.
    output = shell_output("#{bin}/gixy --format=json #{testpath}/vuln.conf 2>&1", 1)
    assert_match "http_splitting", output
  end
end
