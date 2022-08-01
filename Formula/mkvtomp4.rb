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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4d94026b3160bc225ef4d7b7ef96207371b72d5f3e380ceeccd74cb32a2edef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4d94026b3160bc225ef4d7b7ef96207371b72d5f3e380ceeccd74cb32a2edef"
    sha256 cellar: :any_skip_relocation, monterey:       "c43fc3241ef8e5a5f350a8ecb27f81d72970e3444435a2e18f9b75df005e2bab"
    sha256 cellar: :any_skip_relocation, big_sur:        "c43fc3241ef8e5a5f350a8ecb27f81d72970e3444435a2e18f9b75df005e2bab"
    sha256 cellar: :any_skip_relocation, catalina:       "c43fc3241ef8e5a5f350a8ecb27f81d72970e3444435a2e18f9b75df005e2bab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f90f0a5599348e0ef6e1cab3658a290ce0176cc1426da1f8f5e2b733aa77353"
  end

  depends_on "ffmpeg"
  depends_on "gpac"
  depends_on "mkvtoolnix"
  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
    bin.install_symlink bin/"mkvtomp4.py" => "mkvtomp4"
    prefix.install libexec/"share"
  end

  test do
    system "#{bin}/mkvtomp4", "--help"
  end
end
