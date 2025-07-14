class Mkvtomp4 < Formula
  include Language::Python::Virtualenv

  desc "Convert mkv files to mp4"
  homepage "https://github.com/gavinbeatty/mkvtomp4/"
  url "https://files.pythonhosted.org/packages/89/27/7367092f0d5530207e049afc76b167998dca2478a5c004018cf07e8a5653/mkvtomp4-2.0.tar.gz"
  sha256 "8514aa744963ea682e6a5c4b3cfab14c03346bfc78194c3cdc8b3a6317902f12"
  license "MIT"
  revision 3
  head "https://github.com/gavinbeatty/mkvtomp4.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19c4993069753ad76887c0d42e472ab10e86c1888747713f0368d31130997a9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19c4993069753ad76887c0d42e472ab10e86c1888747713f0368d31130997a9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "19c4993069753ad76887c0d42e472ab10e86c1888747713f0368d31130997a9c"
    sha256 cellar: :any_skip_relocation, ventura:       "19c4993069753ad76887c0d42e472ab10e86c1888747713f0368d31130997a9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47a445773cf25560a4dc6e1413e3a4180d4358419d05466c03616f91e9dbd443"
  end

  depends_on "ffmpeg"
  depends_on "gpac"
  depends_on "mkvtoolnix"
  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
    bin.install_symlink "mkvtomp4.py" => "mkvtomp4"
  end

  test do
    system bin/"mkvtomp4", "--help"
  end
end
