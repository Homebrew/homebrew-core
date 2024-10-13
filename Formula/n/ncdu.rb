class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-2.6.tar.gz"
  sha256 "3f471ebd38b56e60dab80c27e3af1d826666957f02d9e8419b149daaf7ade505"
  license "MIT"
  head "https://g.blicky.net/ncdu.git", branch: "zig"

  livecheck do
    url :homepage
    regex(/href=.*?ncdu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "90cfdbbc47079deaf8fd378baaa0e6d9eef06d5ad1824534886d8a36d5a16f37"
    sha256 cellar: :any,                 arm64_sonoma:  "4b36b94f142184f4413c3efd69610f1d3ed5389592c5f6bea10f525bad021c81"
    sha256 cellar: :any,                 arm64_ventura: "25983b0f0db6aaf01e13f683ec327498cc0388a77118549754b0723fc9eadf04"
    sha256 cellar: :any,                 sonoma:        "ff30c04328a783b03fa39919c98192dc56b56bf507c44f10cc2d0c01409d49eb"
    sha256 cellar: :any,                 ventura:       "913ba8eebf38d56648e2ab30c9b278c158c4c41e39d1add5d63c505ed5fb6a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ac219795061a7eeed8e16c4af9663e9cab188a1a4c51d20c94bf8fb0bd20063"
  end

  depends_on "pkg-config" => :build
  depends_on "zig" => :build
  # Without this, `ncdu` is unusable when `TERM=tmux-256color`.
  depends_on "ncurses"
  depends_on "zstd"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[--prefix #{prefix} --release=fast]
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
    system "zig", "build", *args
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
