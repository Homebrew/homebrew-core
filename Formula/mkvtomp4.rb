class Mkvtomp4 < Formula
  include Language::Python::Virtualenv

  desc "Convert mkv files to mp4"
  homepage "https://github.com/gavinbeatty/mkvtomp4/"
  url "https://github.com/gavinbeatty/mkvtomp4/archive/mkvtomp4-v2.0.tar.gz"
  sha256 "0f9aa1754d4b33a6a83c0a71a373836d4872b3288dae9cfb6168c35f09887f2d"
  license "MIT"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "e5c272e7c510016304912ce0a469a46e67fe5a04fd12656c8402882dfe43942d" => :catalina
    sha256 "2767559ea465b35db52e6b7b20ad141f80798402796d3eb67471e26e1ea3cf3e" => :mojave
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
