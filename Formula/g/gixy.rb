class Gixy < Formula
  include Language::Python::Virtualenv

  desc "NGINX configuration static analyzer focused on security"
  homepage "https://gixy.getpagespeed.com/"
  url "https://files.pythonhosted.org/packages/ea/42/396ddcbd6b6a4b40e9eaf0ecc008751b7331458c6d877426e9adc2ae4783/gixy_ng-0.2.61.tar.gz"
  sha256 "a9ac734feae5d7fa55e216cd91fd6a885f4b8819d40446a6b234d607f26f028b"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "18bb39d8af4bc53c0268c780fc3d7f3d34c71c68967fe4ecd81718cf1ddfa414"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3dada8a40013c8bed61554df7914288b35cd3fdd4b7cd9fc81b5ed6a59f1f29a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c33f50c7ed440d7a2037d94fcfe00394fe1fd193ed7edfe5cf0c0918523e88a0"
    sha256 cellar: :any,                 arm64_linux:       "d6cb09472323ecae4aa02e3197fd282b2c3aa7b445c1b28caf9e05f98def85a8"
    sha256 cellar: :any,                 x86_64_linux:      "627062d6e2bf9da8f0ee6223cf2e082bfc9570399ad2f958b2b6e2f1dced7cba"
  end

  depends_on "python@3.15"

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/bc/d9/c591a80cf3335de7820c6762f8ee9298a43da5319803d319e16657b6fdf2/configargparse-1.9.0.tar.gz"
    sha256 "48d9c22affe4ac419b4dd0691fa929d759e1f99574be41826785f2dbf3da63a5"
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
