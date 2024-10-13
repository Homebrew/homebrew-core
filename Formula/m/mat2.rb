class Mat2 < Formula
  include Language::Python::Virtualenv

  desc "Metadata anonymization toolkit"
  homepage "https://0xacab.org/jvoisin/mat2"
  url "https://files.pythonhosted.org/packages/d5/e4/f02d057fe6cf32b68e402c5f86276244105da40161e84ef785b2ae0bf809/mat2-0.13.4.tar.gz"
  sha256 "744aeee924c9898a397fe930593b803c540389bf39cd24553b99a89acc2f5901"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "42f38a593f24363d01036ac610dc2a4d564f3eab8b25d3aca1582c6fcae2d3c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93860914251afac13dec74a1e14949d62f236b838b239dff07a87ae0c5638088"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7697cd25b89af2341c18cf57ed4d23ab72522caa42c5a882af5fb3521c7193d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40e247ea29cb0b1534646f29efefeef1f6fb74066dd2eb66f4765e95d2f84f1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "001e99b10ac8d5f6459b3ab8be250a138f36877cc14ff6b37709d0bf40cee25c"
    sha256 cellar: :any_skip_relocation, ventura:        "ca6e987909afafdd745b4ba1a96401f1c597dfe181bb6c3c9be4f3f384ebca7c"
    sha256 cellar: :any_skip_relocation, monterey:       "1241be881c5f5f62cfb7f569cdb3a247c3b5189617424acec1248ee1fb5f0717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a36b80d2e55d338366518d9a2d8ef20afb739a18037767e71a36910624b34696"
  end

  depends_on "exiftool"
  depends_on "ffmpeg"
  depends_on "gdk-pixbuf"
  depends_on "librsvg"
  depends_on "poppler"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.12"

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  # patch man1 file layout, remove in next release
  # https://0xacab.org/jvoisin/mat2/-/merge_requests/111
  patch do
    url "https://0xacab.org/jvoisin/mat2/-/commit/406924bb6164384fe0a8a8f3dc8dfe7d15577cfc.diff"
    sha256 "4c1c57ca8fe1eabea41d66f3ef9bd4eb2bac8ac181fceeefece4b92b5be9658d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mat2", "-l"
  end
end
