class Casperjs < Formula
  desc "Navigation scripting and testing tool for PhantomJS"
  homepage "http://www.casperjs.org/"
  url "https://github.com/casperjs/casperjs/archive/1.1.4-1.tar.gz"
  version "1.1.4-1"
  sha256 "c95dd17ac58872e9b74dcfd0d55ce22a5545abdae237cc2b9b945fe14c9a2d31"
  head "https://github.com/casperjs/casperjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "885f4f9d0b7e6ceabcde8c5542d14766212e7d189ae426c4bbe6ecd99eb25148" => :sierra
    sha256 "8f0ae4b24ce77c1fa4b93f480dcaa24b64dd0b0b8ac10ea695b91c18d1908568" => :el_capitan
    sha256 "8f0ae4b24ce77c1fa4b93f480dcaa24b64dd0b0b8ac10ea695b91c18d1908568" => :yosemite
  end

  # For embedded Phantomjs
  depends_on :macos => :snow_leopard
  depends_on "phantomjs"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/casperjs"
  end

  test do
    (testpath/"fetch.js").write <<-EOS.undent
      var casper = require("casper").create();
      casper.start("https://duckduckgo.com/about", function() {
        this.download("https://duckduckgo.com/assets/dax-alt.svg", "dax-alt.svg");
      });
      casper.run();
    EOS

    system bin/"casperjs", testpath/"fetch.js"
    assert File.exist?("dax-alt.svg")
  end
end
