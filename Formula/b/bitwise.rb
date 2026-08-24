class Bitwise < Formula
  desc "Terminal based bit manipulator in ncurses"
  homepage "https://github.com/mellowcandle/bitwise"
  url "https://github.com/mellowcandle/bitwise/releases/download/v0.60/bitwise-v0.60.tar.gz"
  sha256 "92727527d53286488751515830afd8934fde75f9d652521c69aea9c9f0e742ad"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fc54a2948967f9fc287bf3a1d255d8a3a2cfef82ddabb2927efeb5bce661c260"
    sha256 cellar: :any, arm64_sequoia: "7751fe7309223b703c2828bc04acce3783027bc7dbb9b8b72fa8519e7b58c349"
    sha256 cellar: :any, arm64_sonoma:  "113a7e5ede2e21afa857cac90a5a99c1f4e2571daf67b053e14d247eeb26e3d1"
    sha256 cellar: :any, sonoma:        "74f6708b451db8e7a745b9e7828ac8a4bc09d3abe648f253a0e68e959661c20a"
    sha256 cellar: :any, arm64_linux:   "bec5d6a42549b954f65b6b16a2680cbed76029765b0099830224f9d8858e3d5c"
    sha256 cellar: :any, x86_64_linux:  "b78d9a4497b0afc97ba3d247b2cdd8b57eb0352c3c0522d4cb206bd7db415b4c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "readline"

  uses_from_macos "ncurses"

  def install
    # `inc/compat.h` is missing from the release tarball; it only declares strndup/l64a fallbacks
    # Upstream PR ref: https://github.com/mellowcandle/bitwise/pull/71
    inreplace "inc/bitwise.h", "#include \"compat.h\"\n", ""

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    assert_match "0 0 1 0 1 0 0 1", shell_output("#{bin}/bitwise --no-color '0x29A >> 4'")
  end
end
