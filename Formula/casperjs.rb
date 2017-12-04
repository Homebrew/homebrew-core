class Casperjs < Formula
  desc "Navigation scripting and testing tool for PhantomJS"
  homepage "http://www.casperjs.org/"
  url "https://github.com/casperjs/casperjs/archive/1.1.4-2.tar.gz"
  version "1.1.4-2"
  sha256 "239b9c95c0e4ab534a3939a8769b5a552315b986472dee967850a407e9b60062"
  head "https://github.com/casperjs/casperjs.git"

  bottle :unneeded

  depends_on "phantomjs"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/casperjs"
  end

  test do
    (testpath/"fetch.js").write <<~EOS
      var casper = require("casper").create();
      casper.start("https://duckduckgo.com/about", function() {
        this.download("https://duckduckgo.com/assets/dax-alt.svg", "dax-alt.svg");
      });
      casper.run();
    EOS

    system bin/"casperjs", testpath/"fetch.js"
    assert_predicate testpath/"dax-alt.svg", :exist?
  end
end
