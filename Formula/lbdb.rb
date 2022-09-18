class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/lbdb/download/lbdb-0.51.1.tar.gz"
  sha256 "97e69fa6535e59869fc42431abe70f5cca4164890d0df2736081a94e1b3625ef"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.spinnaker.de/lbdb/download/"
    regex(/href=.*?lbdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cef87f4c96b20dc2d66a45cce1fe84d0c34e522fb840dc9f0ab6ab2ba4a21e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abedbbd72117fbdbbd9a84a830eb71d6f66ea0d4b7bb3ade48014778f8e80353"
    sha256 cellar: :any_skip_relocation, monterey:       "6bbe0e6abc941d6d9ad924986fe2d4b9eeec2d373239e0a745bb6c152869d51d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e11a8eca1228ce832dd4bfb71f381b7522cc8a93e3fad39b7529339ed45f9aa"
    sha256 cellar: :any_skip_relocation, catalina:       "199b172793df4d2533a158bfc1f24b8d344aa9e184a6172f0ac67774c6ad102d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c269fc118bdaa1049d58e9424e58e67c43fe07f85d39e9c0a83ecb216cc89e24"
  end

  depends_on "abook"

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}/lbdb"
    system "make", "install"
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/lbdbq -v")
  end
end
