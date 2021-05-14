class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-1.1.2.tar.gz"
  sha256 "4172c686b15d1a92f39b3490eea4f56325d7b5f9e6696c1d12c4aedc9706a2d6"
  license "Apache-2.0"

  depends_on "go" => :build

  conflicts_with "ipinfo", because: "ipinfo and ipinfo-cli install the same binaries"

  def install
    system "./ipinfo/build.sh"
    bin.install "build/ipinfo"
  end

  test do
    assert_equal "1.1.2\n", `#{bin}/ipinfo version`
  end
end
