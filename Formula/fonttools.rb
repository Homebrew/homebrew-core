class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.40.0/fonttools-3.40.0.zip"
  sha256 "b1c5f2aa4ed4849ec62f32154118aa46429dc95d8be22d3941369ec9a79ca787"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6ff3a0c63824b447a9108539c3dd97638b87b686503b3b6e5accf7755c723f8" => :mojave
    sha256 "16d7f362d0a988a5a7c36b8c0ffa6a4ebf54f2d20774f4cd71b354a463ac43e2" => :high_sierra
    sha256 "4547971d4bf3edd0d87f53c03ee7f1513d2e9e8c14ac270b4d1a7cab7d782355" => :sierra
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
