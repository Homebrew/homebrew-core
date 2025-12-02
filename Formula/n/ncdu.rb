class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-2.9.2.tar.gz"
  sha256 "e91135281cb66569f2ca4c0bac277246991e7e52524c0ca8cba3de5c8e81cec9"
  license "MIT"
  head "https://g.blicky.net/ncdu.git", branch: "zig"

  livecheck do
    url :homepage
    regex(/href=.*?ncdu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9a08dd709b18d87d90b016b8685d56f2de8d537e437ab44cf4ed92203df7a245"
    sha256 cellar: :any,                 arm64_sequoia: "d56b0ffa80c15fa5758a8b7b59525687a1a04ce043d540936b6db917c7c14c30"
    sha256 cellar: :any,                 arm64_sonoma:  "b86c878b672bb5a7d8644e9908c4ed1ca3fd942095becec43ceff480340d2a2b"
    sha256 cellar: :any,                 sonoma:        "768ace20bc54c22b86ddce63d51bd8488cb04816e28e330286a2685047d5484e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a2d143126f866ae7a7f0aeecc2d12282bde98542e1ece1203d821a8d499343b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "762c13f508d0699c363f0a3a0741a19cbd14d1ef8a86fdd1d70aeaaf2f7bd851"
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
