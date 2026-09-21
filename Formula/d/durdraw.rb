class Durdraw < Formula
  include Language::Python::Virtualenv

  desc "Versatile ASCII and ANSI Art text editor for drawing in the terminal"
  homepage "https://durdraw.org"
  url "https://github.com/cmang/durdraw/archive/refs/tags/0.30.1.tar.gz"
  sha256 "7b33f3216813adf5da296c95b544d70d2f021c8afb837bc395920c1fdd5e18b4"
  license "BSD-3-Clause"
  head "https://github.com/cmang/durdraw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ec53d1a36ea6657ef3c7391e12c4431ae216415f3c1df8a917e626ab137f754"
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
