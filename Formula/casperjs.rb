class Casperjs < Formula
  desc "Navigation scripting and testing tool for PhantomJS"
  homepage "http://www.casperjs.org/"
  url "https://github.com/casperjs/casperjs/archive/1.1.2.tar.gz"
  sha256 "f4f4c3dd99c029dd6a52d0415e5a4dd6527df7ea6b7bb18468b0cda888a2a61a"
  head "https://github.com/casperjs/casperjs.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "a6f6140bcaceabae529d04ddeb152568575091e797b741be8e604e4030e31063" => :el_capitan
    sha256 "e4ad0b7e9f7c8b1a65142a5ac3a82e0adc7f571ba32192019898d0d854362ef5" => :yosemite
    sha256 "dc0297e379af5b10c3ef6e7d8ac00610adf7cb17bf8b1790a7d41b56a0e9692b" => :mavericks
    sha256 "fc20c22ec10d175d84bec4dd05d83fa8ea7fc78723a4e8d0f4041d5c00878651" => :mountain_lion
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
