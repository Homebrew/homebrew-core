class Morse < Formula
  desc "QSO generator and morse code trainer"
  homepage "http://www.catb.org/~esr/morse/"
  url "http://www.catb.org/~esr/morse/morse-2.5.tar.gz"
  sha256 "476d1e8e95bb173b1aadc755db18f7e7a73eda35426944e1abd57c20307d4987"
  license "BSD-2-Clause"
  revision 2

  bottle do
    cellar :any
    sha256 "a956bb32257136228025435a70344d3322b621be1c932e1f61be3fbc1db3b000" => :big_sur
    sha256 "cb06d8049d00c1b52a2c6538ea10918a7623541df2304c1f9c154e042fde868d" => :arm64_big_sur
    sha256 "f489bcc53ec31f5473e2116bd8d4f6867e15501cc8400e9992d1949331d18dee" => :catalina
    sha256 "e696b87957c0215da2e9f600f66460c341b4141b4ef86096dd78d9000a5ceafe" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "pulseaudio"

  def install
    system "make", "all"
    bin.install %w[morse QSO]
    man1.install %w[morse.1 QSO.1]
  end

  test do
    assert_match "Could not initialize audio", shell_output("#{bin}/morse -- 2>&1", 1)
  end
end
