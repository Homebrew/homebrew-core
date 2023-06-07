class Browser < Formula
  desc "Pipe HTML to a browser"
  homepage "https://gist.github.com/318247/"
  url "https://gist.github.com/318247.git",
      revision: "21e65811a50b3cc8bb2b31c658279714657aab96"
  # This the gist revision number
  version "7"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6de7d877522742138bb0668ba627cdd166b2e0b1c698cc336ba704e68c6338e4"
  end

  def install
    # https://gist.github.com/defunkt/318247#gistcomment-3760018
    inreplace "browser", "open", "xdg-open" if OS.linux?
    bin.install "browser"
  end

  test do
    system "#{bin}/browser"
  end
end
