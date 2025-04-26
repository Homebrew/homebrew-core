class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-2.8.tar.gz"
  sha256 "aa61576f7ec9fdf532cb178142ef5b32aad42567705992cf3e0d1c6fe7e38e40"
  license "MIT"
  head "https://g.blicky.net/ncdu.git", branch: "zig"

  livecheck do
    url :homepage
    regex(/href=.*?ncdu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "65e7b7a4bfa0778f42039831c4b676221dd54dce6b4712dfdf5076b815f314c0"
    sha256 cellar: :any,                 arm64_sonoma:  "969fcd255d9bd661e21365e892a81a3ec4ba627bff670c191ce9ac6c479547ce"
    sha256 cellar: :any,                 arm64_ventura: "381da04aa7b67c97792091bef8ab891999999d96f2403609e7046e84b7ea79de"
    sha256 cellar: :any,                 sonoma:        "b51a05f44c243a25bc59f3fb3748c0c049edc5fc7f339f9378c58b35fc74b2a3"
    sha256 cellar: :any,                 ventura:       "4f434c0eda07500bd77df9494bf6f81cca0941b4463ba4e0f3fd0aab9181c89b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b1681ff444ac85caca6d8daa890d29a186b6086b4f6762e26c0ea420a2027a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a146f8836fb916c83063c4eded192bb1d90449b97ea33c8465bbfe86edce901f"
  end

  depends_on "pkgconf" => :build
  depends_on "zig" => :build
  # Without this, `ncdu` is unusable when `TERM=tmux-256color`.
  depends_on "ncurses"
  depends_on "zstd"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = []
    args << "-Dpie=true" if OS.mac?
    args << "-Dcpu=#{cpu}" if build.bottle?

    # Workaround for https://github.com/Homebrew/homebrew-core/pull/141453#discussion_r1320821081
    # Remove this workaround when the same is removed in `zig.rb`.
    if OS.linux?
      ENV["NIX_LDFLAGS"] = ENV["HOMEBREW_RPATH_PATHS"].split(":")
                                                      .map { |p| "-rpath #{p}" }
                                                      .join(" ")
    end

    # Avoid the Makefile for now so that we can pass `-Dcpu` to `zig build`.
    # https://code.blicky.net/yorhel/ncdu/issues/185
    system "zig", "build", *args, *std_zig_args
    man1.install "ncdu.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncdu -v")
    system bin/"ncdu", "-o", "test"
    output = JSON.parse((testpath/"test").read)
    assert_equal "ncdu", output[2]["progname"]
    assert_equal version.to_s, output[2]["progver"]
    assert_equal Pathname.pwd.size, output[3][0]["asize"]
  end
end
