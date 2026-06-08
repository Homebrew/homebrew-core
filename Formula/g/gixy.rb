class Gixy < Formula
  include Language::Python::Virtualenv

  desc "NGINX configuration static analyzer focused on security"
  homepage "https://gixy.getpagespeed.com/"
  url "https://files.pythonhosted.org/packages/d4/82/f998db5d438acbf6ad892fe42fe4da7e6f2288680febef0581d1b8cb972d/gixy_ng-0.2.48.tar.gz"
  sha256 "d1c104ef8b76addd290f652cc688dba3583a7fd77a59d3ce04c6b7a65ae6ab06"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ad245d7f8af7e664cbb2efc86418a1cfbdd5e068523bda1547b751306b13e7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b408bd74683412cac4669526ccbc78f996af870d675a069256eb95f62fbae8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fedad50ce2d47f8ce1c9e4fa38a8ed342d78f4e8ff9bdb2e2605377563c97406"
    sha256 cellar: :any_skip_relocation, sonoma:        "51e99a6386206305139307da1b50a30e3d32dd12efa190f7e24728d7b6074626"
    sha256 cellar: :any,                 arm64_linux:   "3b5eeb85df2a4eab17e259d5dfa22bf2c2b28232549baeb08d1aa332529c07dc"
    sha256 cellar: :any,                 x86_64_linux:  "48fbc3f61342c4a9b0417be40a4c50a40efad9abc8b120dd35683fa02afc666d"
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
