class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-2.4.1.tar.gz"
  sha256 "a0327d925ae0e0c34451b26e539ffc66fa614a40c933bbbb8fcde2dec82c8fec"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c17ecd9001555f7452c45892e41ad352c6977ae59ae6bd313fa29b3e7848b0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a52b0bb4315f6ad226428a0a87b590f0712fa326cd77ef4360017d4ff9bea4b"
    sha256 cellar: :any_skip_relocation, monterey:       "f313f39fa0f4a11e2ed6f93ee1260aa451ebafcee3347837eb803e1a2575595f"
    sha256 cellar: :any_skip_relocation, big_sur:        "027878128db321f16d722f3df42c19a492e218a40ced2b5765d66c4a59d4d186"
    sha256 cellar: :any_skip_relocation, catalina:       "8926249393809267b7c6edcc1594bfc2c8da9c7e435425d85e8d736de98a78a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38287f1224c8e9fa73bcaa50342a83c80ec67ec4ce31afd93b5e9d7da0e66cd0"
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
