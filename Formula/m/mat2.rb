class Mat2 < Formula
  desc "Metadata anonymization toolkit"
  homepage "https://0xacab.org/jvoisin/mat2"
  url "https://files.pythonhosted.org/packages/d5/e4/f02d057fe6cf32b68e402c5f86276244105da40161e84ef785b2ae0bf809/mat2-0.13.4.tar.gz"
  sha256 "744aeee924c9898a397fe930593b803c540389bf39cd24553b99a89acc2f5901"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d819a4c3378ae61661b84cb80b6af98dbad0a428f1df8d449535921f02aa4b0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d70ff80d80b17a49cb04e3a7a9f57193b6c6ecb4d8d16ef4ed3e6c774c1cabf4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b46db4fed2cc62e1d49ea4dae92e377be930a5ec4c68567f238cc040ad9aa2b2"
    sha256 cellar: :any_skip_relocation, ventura:        "e2dd7f2c2173b2b9ed71e7679eaabc566662f29b022ec79bc02e27bfa7c129ba"
    sha256 cellar: :any_skip_relocation, monterey:       "9a853a6c22eea046e1215a2bb0b27285f7d676257804d54372d67463be5c5b32"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2f8e5df6a82ec6922cd6d37f1b5324f5f230cff057e24a3aeee7e7c1aad74ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96f1839a0c399423ac7ceff166d28ea992671b2b52cd1a43fde19d9a8293c5e2"
  end

  depends_on "exiftool"
  depends_on "ffmpeg"
  depends_on "gdk-pixbuf"
  depends_on "librsvg"
  depends_on "poppler"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python-mutagen"
  depends_on "python@3.11"

  # patch man1 file layout, remove in next release
  # https://0xacab.org/jvoisin/mat2/-/merge_requests/111
  patch do
    url "https://0xacab.org/jvoisin/mat2/-/commit/406924bb6164384fe0a8a8f3dc8dfe7d15577cfc.diff"
    sha256 "4c1c57ca8fe1eabea41d66f3ef9bd4eb2bac8ac181fceeefece4b92b5be9658d"
  end

  def python3
    which("python3.11")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system bin/"mat2", "-l"
  end
end
