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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0172b3bc26de89c91c4660b9bb2a7efbe5d02d804eb971ce57eb2f095a8d26c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b17897f565647cc96ef82d31e285e720e7bbf8f24b3ff8ca82982a8f6cf41400"
    sha256 cellar: :any_skip_relocation, ventura:        "27f5efc06b833837ca9bfda6dbd879f638c0f968bf29076145f1ae150e45ad29"
    sha256 cellar: :any_skip_relocation, monterey:       "d50e60e03cf5c79a517df1d861b1c681df15a438e14245443a70187faef0ac32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26c9985853df8ccc0ee242454c6bec5e82d4334262b05f7ec00c153e0a844e6e"
  end

  depends_on "ffmpeg"
  depends_on "gpac"
  depends_on "mkvtoolnix"
  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
    bin.install_symlink bin/"mkvtomp4.py" => "mkvtomp4"
    prefix.install libexec/"share"
  end

  test do
    system "#{bin}/mkvtomp4", "--help"
  end
end
