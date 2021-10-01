class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.9.0.tar.gz"
  sha256 "2530293e94b60d69919a79b49e83270f1462058499ad37a762233df8d6e5992c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 big_sur:      "27aca5fd1d1b212b90575dd385b27cbc215aea9510cab6c24efe18ec15d617cc"
    sha256 catalina:     "a0683b8dce5fd77b89f4ba6412ad1ad7b793abfd2e703f9cff72e2ffe7248d43"
    sha256 mojave:       "30bbc4ad85339e27305d4294cf53e3ddc252f137599b7602ca2930f01728cd8c"
    sha256 x86_64_linux: "722032d357e541908a6d9899a6e77284a4cdeb312c16b3d44485cdfdd0502436"
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
