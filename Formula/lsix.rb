class Lsix < Formula
  desc "Shows thumbnails in terminal using sixel graphics"
  homepage "https://github.com/hackerb9/lsix"
  url "https://github.com/hackerb9/lsix/archive/1.7.3.tar.gz"
  sha256 "88f1855b0272a307758d344a861370c087432ed8f28cc95696659eb0ed7eb960"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d044177e151389e423fe95b95486f46339e19ca8d99e5cadf2ad56e60c060276"
  end

  depends_on "bash"
  depends_on "imagemagick"

  def install
    bin.install "lsix"
  end

  test do
    output = shell_output "#{bin}/lsix 2>&1"
    assert_match "Error: Your terminal does not report having sixel graphics support.", output
  end
end
