class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/26/56/19ba6c01a5c93c0a8cd35f54027133d7a076ef6adfd7e076099c17ee16ff/fonttools-4.24.4.zip"
  sha256 "df7fab667b039cd2a00a1fffcba73a32b2c630ef2a12ab7069ef6df5333f20c3"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cce4badd2ebea6ef588b64d50bfe94968effe42fa6375ec84d1201bfad24fb16"
    sha256 cellar: :any_skip_relocation, big_sur:       "ce61f235ad4d19d9108484bec7cdd80e00f2d8b706480f6f30cea20e407b9a6d"
    sha256 cellar: :any_skip_relocation, catalina:      "ce61f235ad4d19d9108484bec7cdd80e00f2d8b706480f6f30cea20e407b9a6d"
    sha256 cellar: :any_skip_relocation, mojave:        "ce61f235ad4d19d9108484bec7cdd80e00f2d8b706480f6f30cea20e407b9a6d"
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
