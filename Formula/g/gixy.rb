class Gixy < Formula
  include Language::Python::Virtualenv

  desc "NGINX configuration static analyzer focused on security"
  homepage "https://gixy.getpagespeed.com/"
  url "https://files.pythonhosted.org/packages/1a/db/7e99c8fe473d466d62afc49ecdc5d36befd806e6f7a62deb976e86ce3689/gixy_ng-0.2.63.tar.gz"
  sha256 "ccff12aa3fdda85e125d7540aa4b51219ed7ab7e59adbafafffb47d6e4b348a5"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1fd0f8e0580e208835e9dfceacc9a9f28a6ac534c999d5e83470c98782d1bbd5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e9ffdd8c44ceeaab20c7a950a58b73d54b6d1aa1f55de87b9391ed8a35331e0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "318ef49526aa8552c006800c93ef5beaeb3df3d66d9ac99fd4c0480f1817f328"
    sha256 cellar: :any,                 arm64_linux:       "c738529ed3a74cf0ce82c09522cfa1ea1e4a7cf57c5c6b4d2ffc35d4d60e7e6f"
    sha256 cellar: :any,                 x86_64_linux:      "bd8202894308958c780395ab61642cb521ad0547eae26a4c8faa5ce526f5c5fa"
  end

  depends_on "python@3.15"

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/01/77/0ca08089aff2548621a27575d64cb0c0e0e3694e4798211381a65d48dda7/configargparse-1.10.1.tar.gz"
    sha256 "8ee7c4429e6402b881c9a85569eb9484db2f63260718b45c67c59625284371c8"
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
