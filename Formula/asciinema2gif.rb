class Asciinema2gif < Formula
  desc "Generate animated GIFs from asciinema terminal recordings"
  homepage "https://github.com/tav/asciinema2gif"
  url "https://github.com/tav/asciinema2gif/archive/v0.4.1.tar.gz"
  sha256 "a5c78224235a3afb4011c990d5926ddc787d1970b47e7ab46df6fa6eff5d6d90"
  head "https://github.com/tav/asciinema2gif.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "13f2386471efa0beacb5befe8e7c649afe540bb84d3f3e98647bacd5126b77ab" => :sierra
    sha256 "b839220fb7c238038d2e95e783aeddd3008d8fadff6cb10962ecb630600491b2" => :el_capitan
    sha256 "dd6a1126773aa72d9e7697d5df1790ef8abe5fcd8d6e4e122db9a9239725710f" => :yosemite
    sha256 "44fe778a63cbd91a70e0fd2b81b4af8cd3189f4f417ec6d9aa210d9149543a7d" => :mavericks
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
