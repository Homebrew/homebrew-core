class Casperjs < Formula
  desc "Navigation scripting and testing tool for PhantomJS"
  homepage "http://www.casperjs.org/"
  url "https://github.com/casperjs/casperjs/archive/1.1.4.tar.gz"
  sha256 "3afa9210a2676cd9f5cda6227af0b656655b796107108562ec1fef550bdb11e7"
  head "https://github.com/casperjs/casperjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2169e087db1920067eed5cd4c02742d5fc28934224960f34fca01ef7f0cd44cd" => :sierra
    sha256 "2169e087db1920067eed5cd4c02742d5fc28934224960f34fca01ef7f0cd44cd" => :el_capitan
    sha256 "2169e087db1920067eed5cd4c02742d5fc28934224960f34fca01ef7f0cd44cd" => :yosemite
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
