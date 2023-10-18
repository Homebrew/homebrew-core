class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-2.3.tar.gz"
  sha256 "bbce1d1c70f1247671be4ea2135d8c52cd29a708af5ed62cecda7dc6a8000a3c"
  license "MIT"
  head "https://g.blicky.net/ncdu.git", branch: "zig"

  livecheck do
    url :homepage
    regex(/href=.*?ncdu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7c17a54a1c133f106b8ccc577241b977d76de394568b838107c5c397291b6759"
    sha256 cellar: :any,                 arm64_ventura:  "be4225e9e3a60fc201015d0b347b4d6aa91716ec87b48329f5a3fb64201aaede"
    sha256 cellar: :any,                 arm64_monterey: "b9811c7444bc9803111b4473484019a83da067071e7cfbd0e8dfb53970a57098"
    sha256 cellar: :any,                 arm64_big_sur:  "d6e1ccd31a5f1f1f6957743f625444e3cc6328be9831eb0f618c98a6f314e2ad"
    sha256 cellar: :any,                 sonoma:         "690b4e39230bf4639b770f7aa7156a80da6831a51d5344dc177bb23bc04002a1"
    sha256 cellar: :any,                 ventura:        "d7904cf9cf2980d12c5db4f69c9d19b0533fab76190de548af0c69012f1eafd9"
    sha256 cellar: :any,                 monterey:       "c0aeb8ca6c14b2475bd5a60a5b8fc08ba8def91abad411b32a06c88a85597fef"
    sha256 cellar: :any,                 big_sur:        "739dd2be415a7edaff71ab49ac6c5afb830dba6d66ceffe6f54b7683d0e5dfaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6619212d336a2472d712eebc2c44239164ca8253fef4c09ec5268493ba41568"
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

    args = %W[--prefix #{prefix} -Doptimize=ReleaseFast]
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
