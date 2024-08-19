class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/lbdb/download/lbdb-0.54.tar.gz"
  sha256 "1579c38655d5cf7e2c6ca8aabc02b6590c8794ef0ae1fbb0c4d99226ffce5be7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.spinnaker.de/lbdb/download/"
    regex(/href=.*?lbdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1356664e0d455f6454e8105fe21ac8cc2b1919facc10a21f94527cb24118afc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f2c63f1b83751a398957e64f32e3a69900f1271f7080e6a2071bfd74e4faa62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bfb2c099177387127a5538ce370e534b83c68fcbddcd40e1e74eeb9a8aa90b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "069208bf8d2ae5c6a5d3c04ec26fb8c42ffb31b51ad01fc46d970c973b7512c8"
    sha256 cellar: :any_skip_relocation, ventura:        "cc2ccce70a1e46b6cfa83fa7254cfd6155276cf77c3edacc5cbc79a6eee103cd"
    sha256 cellar: :any_skip_relocation, monterey:       "a5266455cc882270c08a6b693cd9099d9c652601d8e7d469e58eb61c9ff59ee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bc185cb81698fe354cd26296f641f7314a1e2f98976355db9437bfd63a6b8f3"
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
