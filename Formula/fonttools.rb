class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/47/7c/dd9dc174842a9bc6fdae89045e820acd8a53a2251b4a8e6d22c97e1c7d75/fonttools-4.25.2.zip"
  sha256 "507f8e027967fe4ebfa913856b3acc6b77201e67d6a6978d3666863cbba884c3"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3becfa0f32a8d1b0c61b8980c8c48ba6a4acfab7fb0609b616f351d2225a9a72"
    sha256 cellar: :any_skip_relocation, big_sur:       "9db5ee7ea5eab0f3a2dd67991318b67507ab4e3477a2ade00910f9a471d6ea4d"
    sha256 cellar: :any_skip_relocation, catalina:      "9db5ee7ea5eab0f3a2dd67991318b67507ab4e3477a2ade00910f9a471d6ea4d"
    sha256 cellar: :any_skip_relocation, mojave:        "9db5ee7ea5eab0f3a2dd67991318b67507ab4e3477a2ade00910f9a471d6ea4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e2507664aeccd68d46963e12e57fbb3689ee130998503213b83dc3c0e9d377f"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    on_macos do
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
    end
    on_linux do
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
