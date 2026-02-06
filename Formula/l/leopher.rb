class Leopher < Formula
  include Language::Python::Virtualenv

  desc "Project encrypts and decrypts messages through Caesar and Vigenère algorithms"
  homepage "https://github.com/lionborn/leopher"
  url "https://github.com/lionborn/leopher/archive/refs/tags/v3.2.tar.gz"
  sha256 "1f800f901728d2b0227ac05b0e35cb73a2a24aa56fab02ee29e00f2c3de1c946"
  license "GPL-3.0-only"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"leopher"
  end
end
