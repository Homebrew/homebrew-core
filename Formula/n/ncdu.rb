class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-2.7.tar.gz"
  sha256 "b218cc14a2bb9852cf951db4e21aec8980e7a8c3aca097e3aa3417f20eb93000"
  license "MIT"
  head "https://g.blicky.net/ncdu.git", branch: "zig"

  livecheck do
    url :homepage
    regex(/href=.*?ncdu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "94e8907cf6b72057a4cc6913ff0a8b942172f82f231384dc2659c2476ffa7a8e"
    sha256 cellar: :any,                 arm64_sonoma:  "1041490c1b919a6d63c9108ff77ed89f62fc12c766ca2be16068a2da553abb94"
    sha256 cellar: :any,                 arm64_ventura: "dbd4d5e5b8d15bfc0923ed9bf43040e04e9f32e8d8d32cae75a26ef1dbc35b3b"
    sha256 cellar: :any,                 sonoma:        "43a6e24ab5ff83297138f2aec826aa6ccc57ca64b8eb3b2f87e64ad7b60b155d"
    sha256 cellar: :any,                 ventura:       "4ffc8d1553dbe38037cb3019c4607afb3c0b22399cc72a6d41b37c2f1a0db4af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bed452df75f7c3eab2ace9ed72104d9a12bc0f75241ab562a1a023b5e5aa9416"
  end

  depends_on "pkgconf" => :build
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
