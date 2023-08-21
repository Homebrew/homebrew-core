class Mkvtomp4 < Formula
  include Language::Python::Virtualenv

  desc "Convert mkv files to mp4"
  homepage "https://github.com/gavinbeatty/mkvtomp4/"
  url "https://files.pythonhosted.org/packages/89/27/7367092f0d5530207e049afc76b167998dca2478a5c004018cf07e8a5653/mkvtomp4-2.0.tar.gz"
  sha256 "8514aa744963ea682e6a5c4b3cfab14c03346bfc78194c3cdc8b3a6317902f12"
  license "MIT"
  revision 3
  head "https://github.com/gavinbeatty/mkvtomp4.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40b20115a22f30e12c87b231eca95ab046e3b83e953b52b72cc854590c1d5b1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40b20115a22f30e12c87b231eca95ab046e3b83e953b52b72cc854590c1d5b1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40b20115a22f30e12c87b231eca95ab046e3b83e953b52b72cc854590c1d5b1e"
    sha256 cellar: :any_skip_relocation, ventura:        "b7cd942202d691603d7168598bbed297c48c231bc3ef6425483899d9b7229a4b"
    sha256 cellar: :any_skip_relocation, monterey:       "b7cd942202d691603d7168598bbed297c48c231bc3ef6425483899d9b7229a4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7cd942202d691603d7168598bbed297c48c231bc3ef6425483899d9b7229a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bf4126d40540e60ed5901ae61ed87bdd039abcc21d834165a882a3932bf925a"
  end

  depends_on "ffmpeg"
  depends_on "gpac"
  depends_on "mkvtoolnix"
  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
    bin.install_symlink bin/"mkvtomp4.py" => "mkvtomp4"
    prefix.install libexec/"share"
  end

  test do
    system "#{bin}/mkvtomp4", "--help"
  end
end
