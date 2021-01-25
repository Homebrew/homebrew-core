class Mkvtomp4 < Formula
  include Language::Python::Virtualenv

  desc "Convert mkv files to mp4"
  homepage "https://github.com/gavinbeatty/mkvtomp4/"
  url "https://files.pythonhosted.org/packages/89/27/7367092f0d5530207e049afc76b167998dca2478a5c004018cf07e8a5653/mkvtomp4-2.0.tar.gz"
  sha256 "8514aa744963ea682e6a5c4b3cfab14c03346bfc78194c3cdc8b3a6317902f12"
  license "MIT"
  revision 2
  head "https://github.com/gavinbeatty/mkvtomp4.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "7122210c51f74465371eb6a92b3d1dd80a27f68f08335dce119b3aeffb9c00cc" => :big_sur
    sha256 "76e2587009f31923054390bd434b37f0fbf898088a79832b00a5ea6331066ae6" => :arm64_big_sur
    sha256 "a4c3cdb9f62d23b6f66827f9fa646c377d60f9d0e5b3dad81eb6c5a67d2798ac" => :catalina
    sha256 "d7ba96f07d2a82d2c5e2d5cce1b80836abdebe0a990f238c763c06aec305ad0a" => :mojave
  end

  depends_on "ffmpeg"
  depends_on "gpac"
  depends_on "mkvtoolnix"
  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
    bin.install_symlink bin/"mkvtomp4.py" => "mkvtomp4"
    prefix.install libexec/"share"
  end

  test do
    system "#{bin}/mkvtomp4", "--help"
  end
end
