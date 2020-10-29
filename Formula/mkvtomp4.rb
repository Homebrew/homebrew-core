class Mkvtomp4 < Formula
  include Language::Python::Virtualenv

  desc "Convert mkv files to mp4"
  homepage "https://github.com/gavinbeatty/mkvtomp4/"
  url "https://github.com/gavinbeatty/mkvtomp4/archive/mkvtomp4-v2.0.tar.gz"
  sha256 "0f9aa1754d4b33a6a83c0a71a373836d4872b3288dae9cfb6168c35f09887f2d"
  license "MIT"
  revision 2

  livecheck do
    url :stable
    regex(/^mkvtomp4[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
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
