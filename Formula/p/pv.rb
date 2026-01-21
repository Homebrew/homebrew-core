class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.10.3.tar.gz"
  sha256 "aa1630c79af6960a8922ffa64d2c3e7f87486da21fcb57e277824294fd266742"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "bb03d9c234fc09170c8a9cefb75bf84d499af7d261830bada070bee81bb95a54"
    sha256 arm64_sequoia: "bc70cc12939d26aa60b3036789db95410aae76b0ebce3b0a54e462b8dae5e81d"
    sha256 arm64_sonoma:  "7a3d2a0aee04bbb008372943680e329473f9287a015040169bcba557cb854445"
    sha256 sonoma:        "863e1f15648fb366d443dc91df94633544eaa6f173542581d32810b88f7e851d"
    sha256 arm64_linux:   "ff3fb9597f711de3dac9eb5d26b496b5d1461a8992366e65ba1f7a28b3d889ee"
    sha256 x86_64_linux:  "2d70e723baa06cd3984b2d78e4a7aff427a18177169a3c0a14b4aba66c4aa12d"
  end

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end
