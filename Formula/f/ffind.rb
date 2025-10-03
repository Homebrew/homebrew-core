class Ffind < Formula
  include Language::Python::Shebang

  desc "Friendlier find"
  homepage "https://github.com/sjl/friendly-find"
  url "https://github.com/sjl/friendly-find/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "cf30e09365750a197f7e041ec9bbdd40daf1301e566cd0b1a423bf71582aad8d"
  license "GPL-3.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "04003304502f97107473f1e6be50bf658ff48ec2f8b3c2b12e743279bbfcb2a7"
  end

  uses_from_macos "python"

  conflicts_with "sleuthkit",
    because: "both install a `ffind` executable"

  def install
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "ffind"
    bin.install "ffind"
    man1.install "ffind.1"
  end

  test do
    system bin/"ffind"
  end
end
