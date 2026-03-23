require File.expand_path("../../Abstract/portable-formula", __dir__)

class PortableZlib < PortableFormula
  desc "General-purpose lossless data-compression library"
  homepage "https://zlib.net/"
  url "https://zlib.net/zlib-1.3.2.tar.gz"
  mirror "https://downloads.sourceforge.net/project/libpng/zlib/1.3.2/zlib-1.3.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zlib-1.3.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zlib-1.3.2.tar.gz"
  sha256 "bb329a0a2cd0274d05519d61c667c062e06990d72e125ee2dfa8de64f0119d16"
  license "Zlib"

  livecheck do
    formula "zlib"
  end

  # https://zlib.net/zlib_how.html
  resource "test_artifact" do
    url "https://zlib.net/zpipe.c"
    version "1.5"
    sha256 "e79717cefd20043fb78d730fd3b9d9cdf8f4642307fc001879dc82ddb468509f"

    livecheck do
      regex(/Version\s+(\d+(?:\.\d+)+)\b/i)
    end
  end

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
