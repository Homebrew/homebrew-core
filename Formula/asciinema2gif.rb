class Asciinema2gif < Formula
  desc "Generate animated GIFs from asciinema terminal recordings"
  homepage "https://github.com/tav/asciinema2gif"
  url "https://github.com/tav/asciinema2gif/archive/v0.5.tar.gz"
  sha256 "2ff5b7145e31db55ebe06c320d3b5d53c42101ec669621344aac0a4fb9f1a4be"
  head "https://github.com/tav/asciinema2gif.git"

  bottle :unneeded

  depends_on "gifsicle"
  depends_on "imagemagick"
  depends_on "phantomjs"

  def install
    (libexec/"bin").install %w[asciinema2gif render.js]
    bin.write_exec_script libexec/"bin/asciinema2gif"
  end

  test do
    system "#{bin}/asciinema2gif", "--help"
  end
end
