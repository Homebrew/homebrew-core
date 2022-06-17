class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.5.0/fish-3.5.0.tar.xz"
  sha256 "291e4ec7c6c3fea54dc1aed057ce3d42b356fa6f70865627b2c7dfcecaefd210"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3d454cba18d2cf0096b6fed748f54f99749d08beaf3ecfc8163e08cd8a6b3e6a"
    sha256 cellar: :any,                 arm64_big_sur:  "59a379c01fc08708dffe0788af6c6c9ed1a408c5b25ce18fe96d17817b0d5f43"
    sha256 cellar: :any,                 monterey:       "58408e5dafbd6840d776b68f384dde61a08f9acdccd1bd41f9c6b5a8ca6aabcb"
    sha256 cellar: :any,                 big_sur:        "7259a66a9d7d14c538c15d621c7bf43b4ab72ce6ad395103276c1b5c4fc1bcb2"
    sha256 cellar: :any,                 catalina:       "416e09deae28f56d228d35dc2a27c6d5545d374bb633318a71b35290f60c5360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25a25d2b499c766f0cba7c9ae268f22925ddba16fe41e2028c1a195c8b9aa40c"
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git"

    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  # Apple ncurses (5.4) is 15+ years old and
  # has poor support for modern terminals
  depends_on "ncurses"
  depends_on "pcre2"

  def install
    args = %W[
      -Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d
      -Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d
      -Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (pkgshare/"vendor_functions.d").mkpath
    (pkgshare/"vendor_completions.d").mkpath
    (pkgshare/"vendor_conf.d").mkpath
  end

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end
