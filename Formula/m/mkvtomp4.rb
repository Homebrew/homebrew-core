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
    rebuild 6
    sha256 cellar: :any_skip_relocation, all: "98cced752f99a3ba028fbdf8d52ef1dc156b9f06d03b5b99f1db8ac601cb7657"
  end

  depends_on "ffmpeg"
  depends_on "gpac"
  depends_on "mkvtoolnix"
  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
    bin.install_symlink "mkvtomp4.py" => "mkvtomp4"
  end

  test do
    system bin/"mkvtomp4", "--help"
  end
end
