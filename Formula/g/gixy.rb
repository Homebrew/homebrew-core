class Gixy < Formula
  include Language::Python::Virtualenv

  desc "NGINX configuration static analyzer focused on security"
  homepage "https://gixy.getpagespeed.com/"
  url "https://files.pythonhosted.org/packages/63/ea/0a3a38b9dfb53cf18efe3fea869f5360e81b37299fe5e86855afd88b8008/gixy_ng-0.2.53.tar.gz"
  sha256 "6dcc4175f48dd1edcc7a2a1def647f2689a465a511361b77b6f00c242f17c86a"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80b10bd0fc1ee5d8f3cdb650c8d49c5e7929171f422232d3d207d2c7afc02c7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e01af078a59092b40876a3b2298ce7486e6879ddead2d976d78407809de16127"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29cde24a85f20275f291d3f182d2e18c08ec4a7c2f34adaf0e64432566ca77a4"
    sha256 cellar: :any,                 arm64_linux:   "a2e661fd15249570f1f65a92be008f5ecfe7d220ebb2516ba9f50ecb5db1546d"
    sha256 cellar: :any,                 x86_64_linux:  "2b7f9a32341b8e8199564bd3218f0e204f4462a7ccbeb504e6259872cdec2b90"
  end

  depends_on "python@3.14"

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/3f/0b/30328302903c55218ffc5199646d0e9d28348ff26c02ba77b2ffc58d294a/configargparse-1.7.5.tar.gz"
    sha256 "e3f9a7bb6be34d66b2e3c4a2f58e3045f8dfae47b0dc039f87bcfaa0f193fb0f"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
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
