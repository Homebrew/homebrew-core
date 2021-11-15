class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.dev/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.4.12.tar.gz"
  sha256 "7a28987114cd5e4717b31a96840c0be505d58a07e20dcf26b25add7dbdf2668b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 monterey:     "0594705207068ce496955651d2aca3e9430d76dfddb6ae038568bd1cb7672848"
    sha256 cellar: :any,                 big_sur:      "643dbd50106a96d8af8e1071c49fb6c41522f7d3384d0e438810d48e5503c7ab"
    sha256 cellar: :any,                 catalina:     "dbf48067fac536bfe804c35c19c6198bae0c0d29107be3e4512d31a37485fd96"
    sha256 cellar: :any,                 mojave:       "d51812440b4e4b8df56ee07b377e2d2a4cee7d84233377218e9ed3fc5e9e68e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e8fed0b8f27357e6414545556caf0c1bffd34273b5966e17c8ef4f554eb2c4a8"
  end

  depends_on "luajit-openresty"

  def install
    inreplace "Lua.h", "/usr/local/include", Formula["luajit-openresty"].opt_include
    system "make", "BUNDLED=0", "LUAJIT_VERSION=2.1"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    mkdir "empty" do
      system "#{bin}/nsm", "init", ".html"
      assert_predicate testpath/"empty/output/index.html", :exist?
    end
  end
end
