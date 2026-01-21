class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://github.com/lcn2/calc/archive/refs/tags/v2.16.1.2.tar.gz"
  sha256 "cb5b0576c3d206ed55b6929cc3a1ebc5afedbfdc70d528274cbac8e650c56d77"
  license "LGPL-2.1-or-later"
  head "https://github.com/lcn2/calc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "f481b5265878ae4d158320b74275baaa57265b3c9e04a546935792f95624ddb8"
    sha256 arm64_sequoia: "304fd017949b04a0df257d62e7b5705c32c5bc70a6d4b79238b0232442a9d92f"
    sha256 arm64_sonoma:  "eee19c041e17491d0f192950d7e1dd0726dbcc7ef1f68e848fce9c5affc7460e"
    sha256 sonoma:        "6aa4af49e85b6e11394ead0c9ca3574638809b12c2db96f2886e6379a9b21133"
    sha256 arm64_linux:   "720d3c2070a317cad9a01e76427644bf9c318b5749444967df4688494b71269c"
    sha256 x86_64_linux:  "d38bf2e1f599b1d351d013276e37ec6d87f8dc999d8b2effaaabe5145fb72392"
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
