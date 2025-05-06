class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-2.8.2.tar.gz"
  sha256 "022fa765d35a79797acdc80c831707df43c9a3ba60d1ae3e6ea4cc1b7a2c013d"
  license "MIT"
  head "https://g.blicky.net/ncdu.git", branch: "zig"

  livecheck do
    url :homepage
    regex(/href=.*?ncdu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8c6101ddddef74f72707d35042f89908d7e4809245aac6922f68ca9e802867ab"
    sha256 cellar: :any,                 arm64_sonoma:  "e2dc1b149d0902dd2a80bbe464dd76a03fc80f60eab9f9310e0ba7918e6ec945"
    sha256 cellar: :any,                 arm64_ventura: "e38712f677f37a2c2e1f0c4b13232ddb4a9a8d9e865f18a506aece66a2f5dbbf"
    sha256 cellar: :any,                 sonoma:        "61dcdfbcc8ec7b2363d0d3ed9243bbb6db3e0faa3c9d846ba0ee09702fd56b39"
    sha256 cellar: :any,                 ventura:       "9e243cfcba2adc77d82a62444d13a200c71f435d203ccdd9241010e47457e58f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "010b5d4e07e41140c166a8066a26a6246f92c9229b6e4327a1a8ca29c99aa096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3390c8fbb71866adbb6099023254feb4cf1112cf8bb6a59418fde4b3ce2dbdce"
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
