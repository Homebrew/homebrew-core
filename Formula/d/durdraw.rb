class Durdraw < Formula
  include Language::Python::Virtualenv

  desc "Versatile ASCII and ANSI Art text editor for drawing in the terminal"
  homepage "https://durdraw.org"
  url "https://github.com/cmang/durdraw/archive/refs/tags/0.29.0.tar.gz"
  sha256 "7878cc0ed97d03defe01f24935f0fbe18d11c1cfc5c3b801ee12c9116dddf0c5"
  license "BSD-3-Clause"
  head "https://github.com/cmang/durdraw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0c308ff22b2a8446c4d611bb3566c612762264b9b9ba19ef2bf333d539b159f"
  end

  depends_on "ansilove" => :no_linkage
  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources

    %w[durdraw.1 durfetch.1 durview.1].each do |file|
      man1.install file
    end

    pkgetc.install "durdraw.ini"
    pkgetc.install "themes"
  end

  def caveats
    <<~EOS
      Default configuration and themes are installed to #{pkgetc}
    EOS
  end

  test do
    # Durdraw is a TUI application
    assert_match version.to_s, shell_output("#{bin}/durdraw --version")
  end
end
