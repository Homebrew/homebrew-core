class Browser < Formula
  desc "Pipe HTML to a browser"
  homepage "https://gist.github.com/318247/"
  url "https://gist.github.com/318247.git",
      revision: "21e65811a50b3cc8bb2b31c658279714657aab96"
  # This the gist revision number
  version "7"

  def install
    bin.install "browser"
  end

  test do
    system "#{bin}/browser"
  end
end
