class Mkvtomp4 < Formula
  include Language::Python::Virtualenv

  desc "Convert mkv files to mp4"
  homepage "https://github.com/gavinbeatty/mkvtomp4/"
  url "https://github.com/gavinbeatty/mkvtomp4/archive/mkvtomp4-v2.0.tar.gz"
  sha256 "0f9aa1754d4b33a6a83c0a71a373836d4872b3288dae9cfb6168c35f09887f2d"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "5d191cf2f5a132c6783cf35a8fb74cb4a8c1c787d07149181f81b2f258172198" => :catalina
    sha256 "5d191cf2f5a132c6783cf35a8fb74cb4a8c1c787d07149181f81b2f258172198" => :mojave
    sha256 "5d191cf2f5a132c6783cf35a8fb74cb4a8c1c787d07149181f81b2f258172198" => :high_sierra
  end

  depends_on "ffmpeg"
  depends_on "gpac"
  depends_on "mkvtoolnix"
  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
    bin.install_symlink bin/"mkvtomp4.py" => "mkvtomp4"
    prefix.install libexec/"share"
  end

  test do
    system "#{bin}/mkvtomp4", "--help"
  end
end
