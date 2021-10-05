class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.9.0.tar.gz"
  sha256 "2530293e94b60d69919a79b49e83270f1462058499ad37a762233df8d6e5992c"
  license "MIT"

  bottle do
    sha256 big_sur:      "8daaa1313d4bde47396ed4f6e0801e937b128b64cc4eb7528325cb27404dd765"
    sha256 catalina:     "4d419018a1b470514b9ee5833dd8062fa56b954ed8ae255a2062554368f0185f"
    sha256 mojave:       "19ad5e81e9f9405ebbbf8ed882e77a9e4c0d32965ebda9012126bcc6dfaa2542"
    sha256 x86_64_linux: "4fba4ea7063d8267fdbb37778f48b020386edc1e7be0268f5dcb42a5b948753c"
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
