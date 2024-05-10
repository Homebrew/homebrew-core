class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v4.9.147.tar.gz"
  sha256 "facac6b9dc857e454fa8ea6555acbb5888c7f1835579a61e4a9b1ab4fbedf908"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe3487eaea4087084c01df9631defbac31a7b8cbfbb5a604f1f5640f4fe4e226"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e30e19f88c31c600e36e90d159aba780df3b0e4c2df220a2ece8f9c4736bf1f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e797ce7f43ab8f0c7c9ac683f6f5572bd603cb4789ceede5a8fd3f6c8e80a92d"
    sha256 cellar: :any_skip_relocation, sonoma:         "67c86c9149b474aeb2044c71dd3389f8f005c044c81ee9e933814f11b6326c2d"
    sha256 cellar: :any_skip_relocation, ventura:        "62b135c84697ebd0d0850a711f3ba1e27e6ccb9c8eb352248a9d0e8695dba703"
    sha256 cellar: :any_skip_relocation, monterey:       "53affd2053cacf7200811c7cd5a3e7568853fce85d6db668a773b0c4dcb7016c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ccbdbba16b59b5119ea5a0f770af471037f86463c6425db554a5873bc19f3b9"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkg-config"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/node-build", "--definitions"
  end
end
