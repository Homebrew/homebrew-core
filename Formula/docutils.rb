class Docutils < Formula
  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.19/docutils-0.19.tar.gz"
  sha256 "33995a6753c30b7f577febfc2c50411fec6aac7f7ffeb7c4cfe5991072dcf9e6"
  license all_of: [:public_domain, "BSD-2-Clause", "GPL-3.0-or-later", "Python-2.0"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68d49b7adbd286d79e538b1d139fccbd16d860fb2711409e9058d53d8f5b456e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68d49b7adbd286d79e538b1d139fccbd16d860fb2711409e9058d53d8f5b456e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68d49b7adbd286d79e538b1d139fccbd16d860fb2711409e9058d53d8f5b456e"
    sha256 cellar: :any_skip_relocation, ventura:        "63d91b072dde1c302435f1c6eea482d3a10cd83d109d2dd12adf192de28ca55f"
    sha256 cellar: :any_skip_relocation, monterey:       "63d91b072dde1c302435f1c6eea482d3a10cd83d109d2dd12adf192de28ca55f"
    sha256 cellar: :any_skip_relocation, big_sur:        "63d91b072dde1c302435f1c6eea482d3a10cd83d109d2dd12adf192de28ca55f"
    sha256 cellar: :any_skip_relocation, catalina:       "63d91b072dde1c302435f1c6eea482d3a10cd83d109d2dd12adf192de28ca55f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63d91b072dde1c302435f1c6eea482d3a10cd83d109d2dd12adf192de28ca55f"
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
