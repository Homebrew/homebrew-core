class Gixy < Formula
  include Language::Python::Virtualenv

  desc "NGINX configuration static analyzer focused on security"
  homepage "https://gixy.getpagespeed.com/"
  url "https://files.pythonhosted.org/packages/e2/d0/e2f4f7c7f32a42504f8523b3d79e199833bb934c59b33804a8b4dbb5465e/gixy_ng-0.2.50.tar.gz"
  sha256 "5db0af3d47e5fba7b7953727fa2db9c3695189ab0c517ffc69c0a3e1ba8836e3"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8972b3e920ed49bf9d8b071695b786aa1590fff86f615485716ff6e728a3220"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "185b38ccd4cf44cbfebb25ac315c5d72e1efb8e2cd9e113af8b250d99189ae05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a5e4b3baef4a5be635daf01df02efb9f4fad1c7d77e617880c2506f07d0027c"
    sha256 cellar: :any_skip_relocation, sonoma:        "95d9bebf5bf5ae905c85ee385a2916fae788e006c059830051a0aae03dfc73c8"
    sha256 cellar: :any,                 arm64_linux:   "69148b042a0f979580ba1ae0c3039b713c646e8d54d9eb5467fd68a0037222d1"
    sha256 cellar: :any,                 x86_64_linux:  "eb68fd966e51a8cb97db3f86cc89de447a2fa7e556f1c55b58241303b9976d85"
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
