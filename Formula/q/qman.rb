class Qman < Formula
  desc "Modern man page viewer"
  homepage "https://github.com/plp13/qman"
  url "https://github.com/plp13/qman/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "785441bf11e99ff27869c08f0d36ce3f5c75db1b045b8712fe515059cf396780"
  license "BSD-2-Clause"

  bottle do
    sha256               arm64_tahoe:   "76e73e941c8644a419e621767c8fcf264fb6648bd2ac9d1ca45036f7771b9662"
    sha256               arm64_sequoia: "242f89831ea2de296836320100941480578948076051262e9c5a4a55f099d7f5"
    sha256               arm64_sonoma:  "d8ed1519a4e75f283581a084d86c58fcb4f9a99ea35fb11848688f1e7542d428"
    sha256               arm64_ventura: "f80ec8da63ae6047755d58a238e6d668ad42f418a0ba2ee4effd1ab357fcce97"
    sha256 cellar: :any, sonoma:        "8413046064145228637319223914e277a13ad7b0eadf201d1f633963d16c89b3"
    sha256 cellar: :any, ventura:       "445caa196096dcbdbc4b3814cc2f2d1d41995fe3d1c4d4b5ce1c1eed911033a7"
    sha256               arm64_linux:   "01382320e7a0ba1239144fcaeca19f9a2c4d4d044fb56ac2dcdf159c873d2ceb"
    sha256               x86_64_linux:  "156d528908713d8438b6da5ca03cd92b9629a3c082f7b417f77e13d253067061"
  end

  depends_on "cogapp" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "groff"
  depends_on "ncurses"

  uses_from_macos "zlib"

  on_linux do
    depends_on "man-db" => :test
    depends_on "libbsd"
  end

  def install
    args = %W[
      -Dtests=disabled
      -Dbzip2=disabled
      -Dlzma=disabled
      -Dconfigdir=#{pkgetc}
    ]
    args += %w[-Dlibbsd=enabled] if OS.linux?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    systype = if OS.mac?
      "darwin"
    else
      "mandb"
    end
    inreplace pkgetc/"qman.conf", "[misc]", <<~EOS
      [misc]
      system_type=#{systype}
      groff_path=#{Formula["groff"].opt_bin}/groff
    EOS
  end

  test do
    match_str = "more modern manual page viewer"
    result = 0

    # Linux CI has no man-related support files
    opts = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      cp_r pkgetc, testpath/"qman"
      inreplace testpath/"qman/qman.conf", "[misc]", <<-EOS
        [misc]
        whatis_path=#{Formula["man-db"].opt_bin}/gwhatis
        apropos_path=#{Formula["man-db"].opt_bin}/gapropos
      EOS
      match_str = "This system has been minimized by removing packages and content"
      result = 2

      "-C #{testpath}/qman/qman.conf"
    end

    assert_match match_str, shell_output("#{bin}/qman #{opts} -T -l #{man1}/qman.1 2>&1", result)
  end
end
