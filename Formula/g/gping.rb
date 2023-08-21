class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/gping-v1.14.0.tar.gz"
  sha256 "8a9c11668e2de8472d551225da1390e89bfbe4a327d120e62f8f65a2270c44f0"
  license "MIT"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2105f80b7281c4bbd6d0d37ffa90bc78923ef39ba0bddf586eb482bdc7408b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd8e1c7198f93d8fd50abadc97ce6dd4e9bd818e471143a60ece22c2d1be9297"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50be5b606ceeddfc10c869ada112de57882add6c5e0df359766825957ae9c2c0"
    sha256 cellar: :any_skip_relocation, ventura:        "fa66777a98614a23c4872e3f80020a05ff9442ac477ef5761a813d0d0a851ca9"
    sha256 cellar: :any_skip_relocation, monterey:       "faf840067b92c85ab6ad65af177fc5224b479a07faf1d52b72252af02a2f385b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2370e1c29a30f40659a2c4bfdf834de48f27b2f68941490eb8c7e24e6e8a0751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd17d33fef88546ca07d7da1c56142549a545199e541f2de8f24ff705a13376e"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_macos do
    depends_on "libgit2"
  end

  on_linux do
    depends_on "iputils"
  end

  def install
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

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end
    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
