class Casperjs < Formula
  desc "Navigation scripting and testing tool for PhantomJS"
  homepage "http://www.casperjs.org/"
  url "https://github.com/casperjs/casperjs/archive/1.1.2.tar.gz"
  sha256 "f4f4c3dd99c029dd6a52d0415e5a4dd6527df7ea6b7bb18468b0cda888a2a61a"
  head "https://github.com/casperjs/casperjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "173fd68859407972910339e63fec3c1a91f925a6be3169f34613368d36536855" => :el_capitan
    sha256 "6e76d1abbe8c2f05996fc1040853f276096b0044da0106d25d8727655ea4540f" => :yosemite
    sha256 "01892cf1ea3199da831de22b8b0ef3541ee727931177a0a9e73a1d671a49737e" => :mavericks
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
