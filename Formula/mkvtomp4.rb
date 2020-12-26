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
    sha256 "e28f9ae16e682b2fecfe4d0a7d93c9b0997266083dcdcc63a42362cd5eb590a6" => :big_sur
    sha256 "87db5af32a6a707a10c11280169dff12f9df3874f93428e49aa14cbfd88eb313" => :catalina
    sha256 "16a6465c2e78d1755d43d1eeba3f1c20605e44a236d892eafcd5cb402c47f060" => :mojave
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
