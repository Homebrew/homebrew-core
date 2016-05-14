class Asciinema2gif < Formula
  desc "Generate animated GIFs from asciinema terminal recordings"
  homepage "https://github.com/tav/asciinema2gif"
  url "https://github.com/tav/asciinema2gif/archive/0.3.tar.gz"
  sha256 "7b05b9abdb71ceef9f8ebb83b43aa00bf10b8138f85bc183c96122c0486c5e98"
  head "https://github.com/tav/asciinema2gif.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f90b2c59593dafb3c991a15b17d82cda792fd2845b55126ba2d3e5765df494e" => :el_capitan
    sha256 "ce148f38246901791b98c8f7a296fb9f1c940411946498960fb8d84eaa569d66" => :yosemite
    sha256 "7d607750f7abf4bf0dd7c810424232f848c72debaafeb75c4dda4b4cc61ddb3b" => :mavericks
  end

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
