class Durdraw < Formula
  include Language::Python::Virtualenv

  desc "Versatile ASCII and ANSI Art text editor for drawing in the terminal"
  homepage "https://durdraw.org"
  url "https://github.com/cmang/durdraw/archive/refs/tags/0.31.1.tar.gz"
  sha256 "c87f67cdb6c1e419bc3ef5d165d06c7408629777fb9d52adddb5c822892a39fb"
  license "BSD-3-Clause"
  head "https://github.com/cmang/durdraw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d9e9b2ead603ff760c2725961a1b7efece1994dfa49449ce9437295d31ddfb62"
  end

  depends_on "ansilove" => :no_linkage
  depends_on "pillow" => :no_linkage
  depends_on "python@3.15"

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
