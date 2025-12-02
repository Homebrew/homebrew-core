class Mat2 < Formula
  include Language::Python::Virtualenv

  desc "Metadata anonymization toolkit"
  homepage "https://0xacab.org/jvoisin/mat2"
  url "https://files.pythonhosted.org/packages/ba/e1/9a8abf4f5ab3c3e214197e310e3f33418d79769ee89911da939a6c891d4f/mat2-0.14.0.tar.gz"
  sha256 "7f07db8c587f91bdfb15fb384bca05d741edc31888bd9844b9e91290c0f529c3"
  license "LGPL-3.0-or-later"

  # FIXME: Fails trying to resolve pygobject as pip tries compiling it but cannot find cairo
  no_autobump! because: "`update-python-resources` cannot determine dependencies"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "17024db2dbe23577339a098b09c29f5a6675af803530aed35a85d156bac2f22e"
  end

  depends_on "exiftool"
  depends_on "ffmpeg"
  depends_on "gdk-pixbuf"
  depends_on "librsvg"
  depends_on "poppler"
  depends_on "py3cairo" => :no_linkage
  depends_on "pygobject3" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "pygobject"

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mat2", "-l"
  end
end
