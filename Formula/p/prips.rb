class Prips < Formula
  desc "Print the IP addresses in a given range"
  homepage "https://devel.ringlet.net/sysutils/prips/"
  url "https://devel.ringlet.net/files/sys/prips/prips-1.3.1.tar.xz"
  sha256 "5369056ec32216ec4aabf93bc410a1b8a40f04003ec923fc0250a4427bfe009d"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://devel.ringlet.net/sysutils/prips/download/"
    regex(/href=.*?prips[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1940f6def034b5898045e7ec3e509288f95c675aae968e80df0949c09f6f782"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1ef5b6bfb220fc96d2cb9e90ffe4acae95989348931bad45da37de64fedf1b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f7fc72cc4a2664dec92aea8401e2d4134bfdb0c571d1ee25518940486d7987f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a5d3dc1178925de340d309f61959b05f01389683bbcb81b470bd2d9ce637199"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a36e6ffe5f5a30a2a16aec993d5f033a85dc1326ec249faf2c72de072862ac1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8735d366c15e87986895455bdba3e87ed3969495fed4c4e2de31a04bad90b072"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust")
    man1.install "prips.1"
  end

  test do
    assert_equal "127.0.0.0\n127.0.0.1",
      shell_output("#{bin}/prips 127.0.0.0/31").strip
  end
end
