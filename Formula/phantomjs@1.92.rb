class PhantomjsAT192 < Formula
  desc "Headless WebKit scriptable with a JavaScript API"
  homepage "http://phantomjs.org/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/phantomjs/phantomjs-1.9.2-macosx.zip"
  sha256 "85a1ddc5c5acb630abbfdc10617b5b248856d400218a9ec14872c7e1afef6698"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac9b23318fd500de6bee2447a79e1fe57c8f5d6c0aab6df6a003e27435ce8cf6" => :sierra
    sha256 "ac9b23318fd500de6bee2447a79e1fe57c8f5d6c0aab6df6a003e27435ce8cf6" => :el_capitan
    sha256 "ac9b23318fd500de6bee2447a79e1fe57c8f5d6c0aab6df6a003e27435ce8cf6" => :yosemite
  end

  depends_on :macos => :snow_leopard

  def install
    bin.install "bin/phantomjs"
  end

  test do
    path = testpath/"test.js"
    path.write <<-EOS
      console.log("hello");
      phantom.exit();
    EOS

    assert_equal "hello", shell_output("#{bin}/phantomjs #{path}").strip
  end
end
