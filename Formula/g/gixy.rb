class Gixy < Formula
  include Language::Python::Virtualenv

  desc "NGINX configuration static analyzer focused on security"
  homepage "https://gixy.getpagespeed.com/"
  url "https://files.pythonhosted.org/packages/ce/b0/2ce6455741358066ae65bd7e8b6f14880d0dcedb0b9996014ba8d7e24c53/gixy_ng-0.2.64.tar.gz"
  sha256 "3cb264372f5ab70316a0221a62488891fd89665b115a15926efa753f90392278"
  license "MPL-2.0"

  bottle do
    manifest_sha256 "0c2a926aa7137d7212f8eedfb2004e929f5243908bb5ee4f7deab1b85050f1d9"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a5f4ca46afa6754597207f1e41e709138253051c969471b1b7b3596a1aa52b27"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ab6dae70e56ab24593344dbbaa0444e84af6d0d2e2a474bcfaba86443033336a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "34dfa4ef40e8d08e304f665a338fdd06e3578104a00a42768073d43e3c31b757"
    sha256 cellar: :any,                 arm64_linux:       "cee0193a157695bdb57e7ae94a5267468960362cb4132ce09b00cf355d651836"
    sha256 cellar: :any,                 x86_64_linux:      "73aefaac4831ab8a9a492f5c48218d8cbf521b446dd0b527e195f003d26ab037"
  end

  depends_on "python@3.15"

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/14/94/269624ec6e8fc8fd5ab6a81c208aea9e02327b8874f9bc254f5379d5a2ec/configargparse-1.10.2.tar.gz"
    sha256 "2deb0b3d6d46ff6e3218fcd350127507c5e3c11e21c8072a9fb24531dfc9bd4a"
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
