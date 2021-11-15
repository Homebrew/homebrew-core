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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "840e763397b239c5ff3423c06ed9d03aa61661c0a50dc4d6ebf663f3afec9f89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfa905b672542169bc3bb6ea8d843fc47bfbce6e1dd2d4777640e1b0e4c2b0cc"
    sha256 cellar: :any_skip_relocation, monterey:       "645888771a0e2957973d28f83ddd531590b7aa7aa8e15b05b638eb39e2f73107"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e924abe22e12f47b13fe0dd30df2e0f9bb41fdbc228a96f44cb9a803c7e0e09"
    sha256 cellar: :any_skip_relocation, catalina:       "eace306eb7517ef959435ce7b8c0efa6fabbb6f5596ac554fc8e71d62687f877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6ff38843218dc26e08f2ef2e48d7f5324332502c84416380359d7153ed3ecb9"
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
