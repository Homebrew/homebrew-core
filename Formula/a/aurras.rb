class Aurras < Formula
  include Language::Python::Virtualenv

  desc "High-end command line music player"
  homepage "https://github.com/vedant-asati03/Aurras"
  url "https://files.pythonhosted.org/packages/source/a/aurras/aurras-2.0.2.tar.gz"
  sha256 "29d44100e708d0f087150ed3cfb98592865a5763034d93268209f18a6eb7165d"
  license "MIT"

  depends_on "python@3.13"
  depends_on "mpv"
  depends_on "ffmpeg"

  def install
    virtualenv_install_with_resources
  end

  test do
    # Test basic command functionality
    system bin/"aurras", "--help"
    assert_match "2.0.2", shell_output("#{bin}/aurras --version 2>&1")
    
    # Test theme functionality (exercises app logic and config system)
    output = shell_output("#{bin}/aurras theme minimal 2>&1", 0)
    assert_match "Theme set to Minimal", output
    
    # Test settings command (exercises config system)
    settings_output = shell_output("#{bin}/aurras settings 2>&1", 0)
    assert_match "settings", settings_output.downcase
  end
end
