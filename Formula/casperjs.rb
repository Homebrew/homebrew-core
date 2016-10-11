class Casperjs < Formula
  desc "Navigation scripting and testing tool for PhantomJS"
  homepage "http://www.casperjs.org/"
  url "https://github.com/casperjs/casperjs/archive/1.1.3.tar.gz"
  sha256 "3e9c385a2e3124a44728b24d3b4cad05a48e2b3827e9350bdfe11c9a6d4a4298"
  head "https://github.com/casperjs/casperjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a4260a5ae64d88e5a15ccba7bf297a7a794b3822838bb8280d6a8c954d45685" => :sierra
    sha256 "b71c26fc5d2d6da94cc95554defbe5db1c6e0213d64ec09fea99755ffd529df4" => :el_capitan
    sha256 "3ca3351236ac827a5cd745087e7763dbd7445e05e4ce05aa11c5bbc7d62d75a6" => :yosemite
    sha256 "082b442968052c819463dacd01b99954f9e2e9e0a5d318c9b7a69e9f31e660f2" => :mavericks
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
