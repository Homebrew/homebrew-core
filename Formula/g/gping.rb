class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/refs/tags/gping-v1.16.1.tar.gz"
  sha256 "557dad6e54b5dd23f88224ea7914776b7636672f237d9cbbea59972235ca89a8"
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
    sha256 cellar: :any,                 arm64_sonoma:   "6c0b8a00018562a56428730081d2149b75e5d70683f112f258c3dd09287e240a"
    sha256 cellar: :any,                 arm64_ventura:  "2f32084a6efef9a3a037b0c9d82299a2258256f6b9b665bbb73fdc8b211b0fd6"
    sha256 cellar: :any,                 arm64_monterey: "4668f27d28670807e0e7e39552f7a20e53d1a093e891ad8948b3a0747f1ef81f"
    sha256 cellar: :any,                 sonoma:         "7d74bf93f8f90500e1e7c9af1cf1f0543dc45f2bd11e3c489a743359874c1859"
    sha256 cellar: :any,                 ventura:        "7efd96965712edc3ebe8a5208758a072d322a1e07b0347838a2400c955111a26"
    sha256 cellar: :any,                 monterey:       "352d66ee19e9a3c4fb133687c331c38fb1a3636bf243d0f1ad348a16065274df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a20f09bff83e703cff8bec5adda1a0d8b2e75cb2bda8a182fea048bf55bb1ef"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  on_linux do
    depends_on "iputils"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
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
