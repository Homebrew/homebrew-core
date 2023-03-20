class Docutils < Formula
  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.19/docutils-0.19.tar.gz"
  sha256 "33995a6753c30b7f577febfc2c50411fec6aac7f7ffeb7c4cfe5991072dcf9e6"
  license all_of: [:public_domain, "BSD-2-Clause", "GPL-3.0-or-later", "Python-2.0"]
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80e64efdb51243a4399e19e4dbf5efe01b855a7cad82ca79c0c6026042f7a00c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "239c9ea68fe0bc3940a3d174291a0733b53b4e1f402e4dc01f7bd5c8636e7e71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83621062b81476f5f69e79a6c49e8844cde4e4ee09610ee5442885f4c9884c35"
    sha256 cellar: :any_skip_relocation, ventura:        "263354453fe6a41c646d4d9b637f71fa5b09ee1d0eb528f1d4b5b5c5d5fe4b72"
    sha256 cellar: :any_skip_relocation, monterey:       "78cc9b7a63475dbe082ccd086bfc0eddddbdbca02a27123b07da1d2e8ae30950"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab3bed820073b8a9bc4d85e4636d22398409bf96698df94fff362470e0bcf8c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31492425c7858c04dd45cfd52cbc464b6c0eec51490863ce420d0aae247ddfd6"
  end

  depends_on "python@3.11"

  def install
    python3 = "python3.11"
    system python3, *Language::Python.setup_install_args(prefix, python3)

    bin.glob("*.py") do |f|
      bin.install_symlink f => f.basename(".py")
    end
  end

  test do
    system bin/"rst2man.py", prefix/"HISTORY.txt"
    system bin/"rst2man", prefix/"HISTORY.txt"
  end
end
