class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.37.0/fonttools-3.37.0.zip"
  sha256 "a1a7f9cce8184d7d5de8d1fc3f6611ba0eca33f038a27710675ec4ddb099c7ad"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb0f97af2b0b70eb888c707757fa8ed22822e3d67759906ad727005c042d4439" => :mojave
    sha256 "4e60d504a5a24d1477a700f1399830d0805b437b7bc8e98dce27274288a4ca2c" => :high_sierra
    sha256 "728c5f5362415eb14d5ed291c27cc6939851e9913073fab0276aa143556e861e" => :sierra
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
