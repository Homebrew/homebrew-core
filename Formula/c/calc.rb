class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://github.com/lcn2/calc/archive/refs/tags/v2.16.1.3.tar.gz"
  sha256 "28cf46a81fc0282f3ef00ca15c3515575e704985cb0f7582b1fb0fe5ac357fc5"
  license "LGPL-2.1-or-later"
  head "https://github.com/lcn2/calc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "fcdfb9d453aa68bf47f2d0ee5bddf0110810e15ef1bad27f44de618b8af6a4b0"
    sha256 arm64_sequoia: "9f4d02743a8467d546ce48f20dd764280980a41e0e19fbadb867d0ece1967067"
    sha256 arm64_sonoma:  "e48efa5e7c5c2e2d3edf5f427990bb75cb00d91c909375699a30262b58c3a7ef"
    sha256 sonoma:        "1b9390eb46c2f7460ec934156d12a1ec8a9ab3d20248343bae677e27c940370b"
    sha256 arm64_linux:   "a1b79d5944bfbc4d44516a76f4231d4aeb4bc6a554c1cf2372f6f54a229ad2ee"
    sha256 x86_64_linux:  "bb6f1c699cd3c06f5746e038a9b68c2cd548620f1ab9cbff4a1220e43453bd93"
  end

  depends_on "readline"

  on_linux do
    depends_on "util-linux" # for `col`
  end

  def install
    ENV.deparallelize

    ENV["EXTRA_CFLAGS"] = ENV.cflags
    ENV["EXTRA_LDFLAGS"] = ENV.ldflags

    args = [
      "BINDIR=#{bin}",
      "LIBDIR=#{lib}",
      "MANDIR=#{man1}",
      "CALC_INCDIR=#{include}/calc",
      "CALC_SHAREDIR=#{pkgshare}",
      "USE_READLINE=-DUSE_READLINE",
      "READLINE_LIB=-L#{Formula["readline"].opt_lib} -lreadline",
      "READLINE_EXTRAS=-lhistory -lncurses",
    ]
    args << "INCDIR=#{MacOS.sdk_path}/usr/include" if OS.mac?
    system "make", "install", *args

    libexec.install "#{bin}/cscript"
  end

  test do
    assert_equal "11", shell_output("#{bin}/calc 0xA + 1").strip
  end
end
