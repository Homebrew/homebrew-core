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
    rebuild 1
    sha256 "7833bb1de72bd88057d2260a9021ce4ec0d5f2925273d537c69549d8e30ebc6d" => :sierra
    sha256 "370e6f729ac20091c408dc5a1be14361b861bef78f1a52efb201e27e7440cfa4" => :el_capitan
    sha256 "ec65660b5c4097886d52fe0b4928aaefd6d09fb0e6ab707b1fa4d762acf873e1" => :yosemite
    sha256 "d837e04d137ae8ddc8eb807b7ca5a08a0fccdfd513f4fdd4f1d610ce8abc0874" => :mavericks
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
