class Mat2 < Formula
  include Language::Python::Virtualenv

  desc "Metadata anonymization toolkit"
  homepage "https://0xacab.org/jvoisin/mat2"
  url "https://files.pythonhosted.org/packages/d5/e4/f02d057fe6cf32b68e402c5f86276244105da40161e84ef785b2ae0bf809/mat2-0.13.4.tar.gz"
  sha256 "744aeee924c9898a397fe930593b803c540389bf39cd24553b99a89acc2f5901"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7540fc693b8b6d49f20b01806636224abb0a1df3a4820b0583849bed74e5ca1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7540fc693b8b6d49f20b01806636224abb0a1df3a4820b0583849bed74e5ca1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7540fc693b8b6d49f20b01806636224abb0a1df3a4820b0583849bed74e5ca1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7540fc693b8b6d49f20b01806636224abb0a1df3a4820b0583849bed74e5ca1f"
    sha256 cellar: :any_skip_relocation, ventura:       "7540fc693b8b6d49f20b01806636224abb0a1df3a4820b0583849bed74e5ca1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3186ddb81c91afdd65c6c3fbc63ea467b15c55b35bcfc8d239362aa6a8bc3af"
  end

  depends_on "exiftool"
  depends_on "ffmpeg"
  depends_on "gdk-pixbuf"
  depends_on "librsvg"
  depends_on "poppler"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.13"

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
