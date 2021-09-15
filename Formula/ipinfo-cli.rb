class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-2.1.1.tar.gz"
  sha256 "136e08ae35eb5b7ba6d4c5ff97c2b4aa342f87a4e53d088cd40c290df3bd9fc1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9a2fad15a7a51ba3d7a81a975b804dda725dee4dbfc3e18c3c1d12f31c0ae3fa"
    sha256 cellar: :any_skip_relocation, big_sur:       "16bdbace0a3525c6bb5c2b88576d54477340cf18de6e61a3cc36124cad9933bc"
    sha256 cellar: :any_skip_relocation, catalina:      "9864acd40e2280331f79a7b8e665dfa5b237beb2f33d935e62109f724e0701a1"
    sha256 cellar: :any_skip_relocation, mojave:        "368f06b63d241c5ffe492247243e33a12f2f20566d5fab5f89eb274d61f20020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffbcaf8e3ef599cdb377bd76e3657ff67aff3ade0bde1f2feecda56999571bdc"
  end

  depends_on "go" => :build

  conflicts_with "ipinfo", because: "ipinfo and ipinfo-cli install the same binaries"

  def install
    system "./ipinfo/build.sh"
    bin.install "build/ipinfo"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/ipinfo version").chomp
    assert_equal "1.1.1.0\n1.1.1.1\n1.1.1.2\n1.1.1.3\n", `#{bin}/ipinfo prips 1.1.1.1/30`
  end
end
