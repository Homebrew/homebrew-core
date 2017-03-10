class PhantomjsAT192 < Formula
  desc "Headless WebKit scriptable with a JavaScript API"
  homepage "http://phantomjs.org/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/phantomjs/phantomjs-1.9.2-macosx.zip"
  sha256 "85a1ddc5c5acb630abbfdc10617b5b248856d400218a9ec14872c7e1afef6698"

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
