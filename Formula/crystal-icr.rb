class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.8.0.tar.gz"
  sha256 "8c7825dd035bbb4bc6499873d4bd125185a01cae10dc8dd6f98e6e013def381c"

  bottle do
    sha256 "22389822712ed2a634ba8d32817a29e0930eb53669d4c931f740b5c895de9ed4" => :catalina
    sha256 "5c73c5c37ed0cd5ceb6fc72f88afe4a9156417a0e4752e93500d0aec755646c0" => :mojave
    sha256 "1ea960e6dd1eeffc8c7e9471a2e17e9dc912eccdc7558d18346a856c10e078bb" => :high_sierra
  end

  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@1.1"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end
