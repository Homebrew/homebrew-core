class Phantomjs < Formula
  desc "Headless WebKit scriptable with a JavaScript API"
  homepage "http://phantomjs.org/"
  head "https://github.com/ariya/phantomjs.git"

  stable do
    url "https://github.com/ariya/phantomjs.git",
        :tag => "2.1.1",
        :revision => "d9cda3dcd26b0e463533c5cc96e39c0f39fc32c1"

    # Fixes build.py for non-standard Homebrew prefixes.  Applied
    # upstream, can be removed in next release.
    patch do
      url "https://github.com/ariya/phantomjs/commit/6090f5457d2051ab374264efa18f655fa3e15e79.diff"
      sha256 "43c7d2c76db434aa845c0504209052af6011a20d1295b203c3bee881071aa471"
    end
  end

  bottle do
    cellar :any
    sha256 "f66255cd772834de297a10fc7053800bfbd99c4833196958c18f05299dec6bc9" => :el_capitan
    sha256 "0ba4152cce3869cc01ed697d9bbf4dfe55d7749693dfbf6bede24c191c0f177f" => :yosemite
    sha256 "908cacf9af85893f54c5330987099896448c2699a7f3712de3e2232348c433b2" => :mavericks
  end

  depends_on MinimumMacOSRequirement => :lion
  depends_on :xcode => :build
  depends_on "openssl"

  def install
    ENV["OPENSSL"] = Formula["openssl"].opt_prefix
    system "./build.py", "--confirm", "--jobs", ENV.make_jobs
    bin.install "bin/phantomjs"
    pkgshare.install "examples"
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
