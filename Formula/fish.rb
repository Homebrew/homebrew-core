class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.4.0/fish-3.4.0.tar.xz"
  sha256 "b5b48ab8486b19ef716a32f7f46b88b9ea5356155f0e967ee99f4093645413c5"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0f87e924275eedd76ea943b27f9c8df3ca8a7ece90e108d2714e35a2e7a26373"
    sha256 cellar: :any,                 arm64_big_sur:  "817d8158f193b6dd0d9b0ef212617f5465492adbe6da3af7f9a51af25114705b"
    sha256 cellar: :any,                 monterey:       "6e21c1ed7f2e7e3a2480a9bb8c9b9845d1bd57d25f33cbf506fec17a4c619f7c"
    sha256 cellar: :any,                 big_sur:        "58212e21816352f12a9e5a4de5269320db6796811c14e5a8e3e4e687ff4e6528"
    sha256 cellar: :any,                 catalina:       "0636cd4420bd3dfe58c6b8f9ab5dc85adda72b02750ce383ced94ceaa6c3a57b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c0dc8d884d8f613cfbba4576454f06d97f71c41233f7d6f2b968ba37a20a62f"
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
