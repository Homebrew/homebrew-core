class Gixy < Formula
  include Language::Python::Virtualenv

  desc "NGINX configuration static analyzer focused on security"
  homepage "https://gixy.getpagespeed.com/"
  url "https://files.pythonhosted.org/packages/d0/83/cf79fd3f75709421718a530d9f1adce780791060e1d02eb2be890f77d73e/gixy_ng-0.2.51.tar.gz"
  sha256 "55b7edf4c99cdacce07138435fa5ddb26e2fd53c8b05732d667758a27365431c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ffed10e12d3730d0b703bb18c82472fb99b457b525b5e721aa2c053e4393c74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d74ed86f27b53466577dc1570b7e68c16ba641d0c9faaf7281f891cb921ef8ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b92c0cf070f5887089c9ed9e4beba6f483521df95c296828033d9838bbb7e18"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d23f2c2bb79cb1cc7aee6ae2bbc772260d87c9ce581315da7983f6ff0e0635b"
    sha256 cellar: :any,                 arm64_linux:   "53e68a9713dc29001b846ce600c7c35520055b12a481e193d0b725cf14debe1d"
    sha256 cellar: :any,                 x86_64_linux:  "10d848c861f7e2212eaac0b03a61caeb9c01a078541ee48b510b7785e4777bb8"
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
