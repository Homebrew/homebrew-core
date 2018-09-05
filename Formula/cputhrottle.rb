class Cputhrottle < Formula
  desc "Limit the CPU usage of a process"
  homepage "http://www.willnolan.com/cputhrottle/cputhrottle.html"
  url "http://www.willnolan.com/cputhrottle/cputhrottle-1.0.0.tar.gz"
  sha256 "08243656d0abf6dd5fd9542d33553507ce395ee4e0a1aeb5df08ca78bc83ec21"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "1ccf8955c3a4f740ae831c8d1620ff50bf7e09b3f989b0968b7420596901ba68" => :mojave
    sha256 "14cfa66d900ac9b9623452b1734476d9a2b7c90358ea3f0f3f028169d08b1f52" => :high_sierra
    sha256 "e7b1f37f5624959be9ebd8b7ddb44eb90907e2d08f1a1755ed818e38370a30c9" => :sierra
    sha256 "44fe4915b0be45c45c9ce09036869b54c2172742d787c3888b3cb5a7f0a30330" => :el_capitan
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
