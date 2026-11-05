require File.expand_path("../../Abstract/portable-formula", __dir__)

class PortableZlib < PortableFormula
  desc "General-purpose lossless data-compression library"
  homepage "https://zlib.net/"
  url "https://zlib.net/zlib-1.4.tar.gz"
  mirror "https://github.com/madler/zlib/releases/download/v1.4/zlib-1.4.tar.gz"
  sha256 "02dd159783677a749c04adbdd02b55b8a2bcc7e054f51b76b549199a916ad584"
  license "Zlib"
  compatibility_version 1

  livecheck do
    formula "zlib"
  end

  # https://zlib.net/zlib_how.html
  resource "test_artifact", :test do
    url "https://raw.githubusercontent.com/madler/zlib/refs/tags/v1.4/examples/zpipe.c"
    sha256 "e79717cefd20043fb78d730fd3b9d9cdf8f4642307fc001879dc82ddb468509f"

    livecheck do
      formula :parent
    end
  end

  deny_network_access!

  def install
    system "./configure", "--static", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testpath.install resource("test_artifact")
    system ENV.cc, "zpipe.c", "-I#{include}", "-L#{lib}", "-lz", "-o", "zpipe"

    touch "foo.txt"
    output = "./zpipe < foo.txt > foo.txt.z"
    system output
    assert File.exist?("foo.txt.z")
  end
end
