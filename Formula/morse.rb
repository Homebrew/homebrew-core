class Morse < Formula
  desc "QSO generator and morse code trainer"
  homepage "http://www.catb.org/~esr/morse/"
  url "http://www.catb.org/~esr/morse/morse-2.5.tar.gz"
  sha256 "476d1e8e95bb173b1aadc755db18f7e7a73eda35426944e1abd57c20307d4987"
  license "BSD-2-Clause"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?morse[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c10ed6e8fcfc5eba8f26332554eab00725618885103a64012ae1439d6086a8b6"
    sha256 cellar: :any,                 arm64_monterey: "a35043d1c63aa545d5bedb01c1e84c425a30f2b991468a00cd7a5aa12ee14d91"
    sha256 cellar: :any,                 arm64_big_sur:  "cb06d8049d00c1b52a2c6538ea10918a7623541df2304c1f9c154e042fde868d"
    sha256 cellar: :any,                 ventura:        "364dda70103cf7696e1a8f5b7506fa7a34bfce18f4a3a5552015b71dde9192e8"
    sha256 cellar: :any,                 monterey:       "ed97cdede281a1b7adf2c483cca6630fbf91a4180724f58ea9a313a886bce8d1"
    sha256 cellar: :any,                 big_sur:        "a956bb32257136228025435a70344d3322b621be1c932e1f61be3fbc1db3b000"
    sha256 cellar: :any,                 catalina:       "f489bcc53ec31f5473e2116bd8d4f6867e15501cc8400e9992d1949331d18dee"
    sha256 cellar: :any,                 mojave:         "e696b87957c0215da2e9f600f66460c341b4141b4ef86096dd78d9000a5ceafe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50847c19aed821be27839b60979e43ffd45f9c3ba66a469421a6204d950ffad2"
  end

  depends_on "pkg-config" => :build
  depends_on "pulseaudio"

  def install
    system "make", "all"
    bin.install %w[morse QSO]
    man1.install %w[morse.1 QSO.1]
  end

  test do
    # Fails in Linux CI with "pa_simple_Write failed"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "Could not initialize audio", shell_output("#{bin}/morse -- 2>&1", 1)
  end
end
