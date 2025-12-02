class Pbzx < Formula
  desc "Parser for pbzx stream"
  homepage "https://github.com/NiklasRosenstein/pbzx/"
  url "https://github.com/NiklasRosenstein/pbzx/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "33db3cf9dc70ae704e1bbfba52c984f4c6dbfd0cc4449fa16408910e22b4fd90"
  license "GPL-3.0-or-later"
  head "https://github.com/NiklasRosenstein/pbzx.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "ecaa1ce184ca795a79c535697ba31b5a4149599641d561248263f27bf175c9ca"
    sha256 cellar: :any, arm64_sonoma:   "37c826c9cf597002de46eeec44865b96760d06533ca6eee7352721f2fb8cf1c4"
    sha256 cellar: :any, arm64_ventura:  "2daae05cf14027d7cefc132e705bf69a04e4fd5425c4856bda3ba33da6ce575f"
    sha256 cellar: :any, arm64_monterey: "52198369eac9a2ce3b84a3d293517c84dd9fbea20010379ece7ac849cedeba2c"
    sha256 cellar: :any, arm64_big_sur:  "12bb9d8f9ab80e43ed3627ffb4add78ab55d965814b8e2551ef78426ee47c869"
    sha256 cellar: :any, sonoma:         "b345f7bcd1e71ce488c316ecd1396a43e12c8f9bafebf5a31eb8dcae1b687ae1"
    sha256 cellar: :any, ventura:        "3b5afc8a47a77098c4d0d223cca7b74793a42785bf0d60274aaa841abf1d576d"
    sha256 cellar: :any, monterey:       "40bd57e2e67b8558e65a82a981cd864c2f9644a90475e942423a631b6cdfd190"
    sha256 cellar: :any, big_sur:        "8444ecb5864ac3a5324a92620b3ac280deac66cc09621cd7cdc1c5e8b94f119b"
    sha256 cellar: :any, catalina:       "c6d161a1c58bcbc3e1f6d8bcf7ec567a0f93cafe626849838cf4d8ec4c90044a"
  end

  deprecate! date: "2024-03-13", because: :repo_archived
  disable! date: "2025-03-24", because: :repo_archived

  # pbzx is a format employed OSX disk images
  depends_on :macos
  depends_on "xz"

  def install
    system ENV.cc, "-llzma", "-lxar", "pbzx.c", "-o", "pbzx"
    bin.install "pbzx"
  end

  test do
    assert_match "0 blocks", shell_output("#{bin}/pbzx -n Payload | cpio -i 2>&1")

    assert_match version.to_s, shell_output("#{bin}/pbzx -v")
  end
end
