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
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b0211e548f427a745a616acb0040ac4bee43dbbba351058c7db51737848bdd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28cd8a440b014863414812ca1c0b5dc7a53ca5679cc6186c56043c870b388cf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c25c3203f036ed522c4b5bdaacda644afc1828e245f8d6661e620d69eaf5883"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c67f86549714e14becca9a1b5e86bb07615d4249bc892d967c1ee4b80ef20a2"
    sha256 cellar: :any_skip_relocation, ventura:        "272f9a3386061722abfe5d8a8cfc1659b54eebdc2738739b5119986262bb01d0"
    sha256 cellar: :any_skip_relocation, monterey:       "d089374400cccda7d73f4d34069831da18fb48e230f6525d3c788585dcb532f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d341dd943da6c2447fc8110ae4fde421c4205d69f343e5810fd07dc1b6a4fc7"
  end

  depends_on "ffmpeg"
  depends_on "gpac"
  depends_on "mkvtoolnix"
  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
    bin.install_symlink "mkvtomp4.py" => "mkvtomp4"
  end

  test do
    system "#{bin}/mkvtomp4", "--help"
  end
end
