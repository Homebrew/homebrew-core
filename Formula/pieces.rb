class Pieces < Formula
  desc "A command line application for Pieces"
  homepage "https://code.pieces.app/"
  url "https://storage.googleapis.com/app-releases-59612ba/pieces-cli/release/pieces-1.0.0.tar.gz"
  sha256 "cd31a46a7606b461c2c7cba6b2d3a5184908aa47fd8c900bb233262e4e3858fd"
  license "MIT"

  on_linux do
    depends_on "xsel"
  end

  def install
	if OS.linux?
		bin.install "pieces-linux" => "pieces"
	else
		bin.install "pieces-mac" => "pieces"
	end
  end

  test do
    assert_match "dart", shell_output("#{bin}/pieces snippet-types")
  end
end
