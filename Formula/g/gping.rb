class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  # TODO: check if we can use unversioned `libgit2` at version bump.
  # See comments below for details.
  url "https://github.com/orf/gping/archive/refs/tags/gping-v1.14.0.tar.gz"
  sha256 "8a9c11668e2de8472d551225da1390e89bfbe4a327d120e62f8f65a2270c44f0"
  license "MIT"
  revision 1
  head "https://github.com/orf/gping.git", branch: "master"

  # The GitHub repository has a "latest" release but it can sometimes point to
  # a release like `v1.2.3-post`, `v1.2.3-post2`, etc. We're checking the Git
  # tags because the author of `gping` requested that we omit `post` releases:
  # https://github.com/Homebrew/homebrew-core/pull/66366#discussion_r537339032
  livecheck do
    url :stable
    regex(/^gping[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "12a9bd754d2f1597e89d5cc6690af8af14d2d3836b974f90452abe849c5c6c6f"
    sha256 cellar: :any,                 arm64_monterey: "9ffad7b6407af60c32cffcd3099d50e57f74a25e601864c3dc2712eb2dec00ae"
    sha256 cellar: :any,                 arm64_big_sur:  "8df9a4ea92dbc359024d08fa8c6a3dcf9d55ce828b4975a8f5d82bb6ce0a65d2"
    sha256 cellar: :any,                 ventura:        "853207d921bf41d05992e8fd5c874992865040e9fba970ca7566b26fa0509e61"
    sha256 cellar: :any,                 monterey:       "6f6b83f8510cb0f67f3bdf123c22a9b5f73e5fc64be5aebff7a0ce2591e21aa7"
    sha256 cellar: :any,                 big_sur:        "df95fab0f12d5d4ceeab96132e1220f3fc70bdcc435403c15e3db047219ea5c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b7fc0ff3c261dc5b8d94ecac8ee501f15e9e8d6323bbd82da43c20ff785c050"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_macos do
    # To check for `libgit2` version:
    # 1. Search for `libgit2-sys` version at https://github.com/orf/gping/blob/gping-#{version}/Cargo.lock
    # 2. If the version suffix of `libgit2-sys` is newer than +1.6.*, then:
    #    - Migrate to the corresponding `libgit2` formula.
    #    - Change the `LIBGIT2_SYS_USE_PKG_CONFIG` env var below to `LIBGIT2_NO_VENDOR`.
    #      See: https://github.com/rust-lang/git2-rs/commit/59a81cac9ada22b5ea6ca2841f5bd1229f1dd659.
    depends_on "libgit2@1.6"
  end

  on_linux do
    depends_on "iputils"
  end

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    system "cargo", "install", *std_cargo_args(path: "gping")
  end

  test do
    require "pty"
    require "io/console"

    r, w, = PTY.spawn("#{bin}/gping google.com")
    r.winsize = [80, 130]
    sleep 1
    w.write "q"

    begin
      screenlog = r.read
      # remove ANSI colors
      screenlog.encode!("UTF-8", "binary",
        invalid: :replace,
        undef:   :replace,
        replace: "")
      screenlog.gsub!(/\e\[([;\d]+)?m/, "")

      assert_match "google.com (", screenlog
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end

    return unless OS.mac?

    linkage_with_libgit2 = (bin/"gping").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.6"].opt_lib/shared_library("libgit2")).realpath.to_s
    end
    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
