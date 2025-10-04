class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-2.9.1.tar.gz"
  sha256 "bfd1094e1400ee89cfd59200eab940f025ccdc0c238067105c984a3c4857bf7e"
  license "MIT"
  head "https://g.blicky.net/ncdu.git", branch: "zig"

  livecheck do
    url :homepage
    regex(/href=.*?ncdu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "19116f09a74053a249d193db0fa3315e2440e24babfa56ca8bbfc5b3e315265c"
    sha256 cellar: :any,                 arm64_sequoia: "e946696247e04ba05222fd3663bd1f19f4175ad5e1789be185268e44f2efcdba"
    sha256 cellar: :any,                 arm64_sonoma:  "5a58cfe5cadc5dd0967ba98f10247c4d6e744136e1f20d017a7b8b9c841a670a"
    sha256 cellar: :any,                 arm64_ventura: "b198a6841fd6805099414848220f120ab0aceedf605fcbcd1b7b2d5fd6cb0dc8"
    sha256 cellar: :any,                 sonoma:        "0f0b4c07f0c7668d583ebd828b1166f5594ca2ecb7b6175d839e2e50ba7c8bde"
    sha256 cellar: :any,                 ventura:       "d88a4512e7e1ade70fb23daff251a30402b4ede1b52fa7456fe0cf2332da3460"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2abb6cf76c760880f9dad57f3ac7ede70ee511eaf5163f04839462080563d7cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18844ed42709179573f5e225fb79af10f0d551da58d2fad67e30ed4c909343a5"
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
