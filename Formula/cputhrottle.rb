class Cputhrottle < Formula
  desc "Limit the CPU usage of a process"
  homepage "http://www.willnolan.com/cputhrottle/cputhrottle.html"
  url "http://www.willnolan.com/cputhrottle/cputhrottle-1.0.0.tar.gz"
  sha256 "08243656d0abf6dd5fd9542d33553507ce395ee4e0a1aeb5df08ca78bc83ec21"
  version_scheme 1

  bottle do
    sha256 "32da8a76bd7589b850afe95fce181cfa7d2efd68724bea9e81f57609edbce854" => :sierra
    sha256 "4f80fe27e2a64468ab6613f526552003adb11125db9ac3aa7aee1c5d70d86653" => :el_capitan
    sha256 "5196a098d92dbf7c9f1ed5c5a7350bbcdbdc07e0292565cf7729a3bb7de5f972" => :yosemite
    sha256 "6df740581ec759d149a2f456da278361fcff522718799b5a24ca03762f8908b2" => :mavericks
  end

  def install
    system "make", "all"
    bin.install "cputhrottle"
  end

  test do
    # Needs root for proper functionality test.
    output = pipe_output("#{bin}/cputhrottle 2>&1")
    assert_match "Please supply PID to throttle", output
  end
end
