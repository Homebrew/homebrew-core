class Aurras < Formula
  include Language::Python::Virtualenv

  desc "High-end command line music player"
  homepage "https://github.com/vedant-asati03/Aurras"
  url "https://files.pythonhosted.org/packages/source/a/aurras/aurras-2.0.2.tar.gz"
  sha256 "29d44100e708d0f087150ed3cfb98592865a5763034d93268209f18a6eb7165d"
  license "MIT"

  depends_on "python@3.12"
  depends_on "mpv"
  depends_on "ffmpeg"

  def install
    virtualenv_install_with_resources
  end

  test do
    # Test that the application can display help without errors
    system bin/"aurras", "--help"
    # Test that the version command works
    assert_match "2.0.2", shell_output("#{bin}/aurras --version 2>&1")
  end
end
