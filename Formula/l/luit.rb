class Luit < Formula
  desc "Filter run between arbitrary application and UTF-8 terminal emulator"
  homepage "https://invisible-island.net/luit/"
  url "https://invisible-mirror.net/archives/luit/luit-20230201.tgz"
  sha256 "ee2a8d1dbc7ee23d00c412a1f0b3d70678514d56d5be0a816dd95e232e76c56f"
  license "MIT"

  livecheck do
    url "https://invisible-mirror.net/archives/luit/"
    regex(/href=.*?luit[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2921f3e72c9dd839dda3c52815a028d205136849b2ced7f5ca395c4949ff5c5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ad950b090ec568a426659521613dcf408a61a88ccc146de912f5b2b2c2187bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac0a89fc8a5ae33805e22959345b871ae09324c684c48147eaed4cf76ef47723"
    sha256 cellar: :any_skip_relocation, ventura:        "5d7ac0c9eb7e4d3e44c023e4ee3ae398140b589deb81430a10beee9ebf257931"
    sha256 cellar: :any_skip_relocation, monterey:       "6c5ca1a5b9e177545e5f34275b8c16b5e23d0fe2e5b4b7ac8df71a38e8495916"
    sha256 cellar: :any_skip_relocation, big_sur:        "bebbd81806a71c8fdbca34f7b4c1cefd1f421b8a4c1bf5de02e006c929999f8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85589978fc902e61d62615feb5df1a3e99c4087171260a3069cf8976a20b9fed"
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}", "--without-x"
    system "make", "install"
  end

  test do
    require "pty"
    (testpath/"input").write("#end {bye}\n")
    PTY.spawn(bin/"luit", "-encoding", "GBK", "echo", "foobar") do |r, _w, _pid|
      assert_match "foobar", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
