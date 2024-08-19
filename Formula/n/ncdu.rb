class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-2.5.tar.gz"
  sha256 "7f49de25024abab1af1ff22b3b8542c0d158e018fe0e96074fd94b0e1e6d31a5"
  license "MIT"
  head "https://g.blicky.net/ncdu.git", branch: "zig"

  livecheck do
    url :homepage
    regex(/href=.*?ncdu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1cba8bbb35dc36a9686ff4182b395969cf1de154652b2d6134c2836e531b169a"
    sha256 cellar: :any,                 arm64_ventura:  "8478d4058dc184f43368ca19c32aecf5a7be3a4f7175fb41a59f5202f170288f"
    sha256 cellar: :any,                 arm64_monterey: "4abb7c99e405c3b4d7ef4179e60d7c4ab518a307df825db3dd60859ea3ae7d55"
    sha256 cellar: :any,                 sonoma:         "520c686c473bc3b7b8dc780449d463dc31f79f981e493e06fbe862c8c9fa2c0b"
    sha256 cellar: :any,                 ventura:        "b56d7f67705f119b611268352a7befa25bf464187644fbafe427526d31019418"
    sha256 cellar: :any,                 monterey:       "bcd6481c81cae50583faad16cd085541abfad8b592bca93ad4a3d7b0ed99bd00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb76582ce7c7cd84b8b994839d50672c2c14db35ca06469a5d09215bdfb6a3dd"
  end

  depends_on "pkg-config" => :build
  depends_on "zig" => :build
  # Without this, `ncdu` is unusable when `TERM=tmux-256color`.
  depends_on "ncurses"

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
