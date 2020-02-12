class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.1.0/fish-3.1.0.tar.gz"
  sha256 "e5db1e6839685c56f172e1000c138e290add4aa521f187df4cd79d4eab294368"

  bottle do
    cellar :any
    sha256 "895edf3ca5bf3e3774a3f625b7c765868862dc8524fb68e83ce288ae0dbffdd0" => :catalina
    sha256 "0dda76c64b0e2b4f1bfe48b816346f54a3fd9531550439caadadc6a1641c6d6b" => :mojave
    sha256 "aaa15fbea68f8414084124da4347aec31484a3ab6320daf5f1cd54e208bf32c1" => :high_sierra
    sha256 "65eb56f5d3e5978051743e0e1a6616983f34922cad65cbe0964b671d9bf4437e" => :sierra
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", :shallow => false

    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  depends_on "pcre2"
  uses_from_macos "ncurses"

  def install
    # In Homebrew's 'superenv' sed's path will be incompatible, so
    # the correct path is passed into configure here.
    args = %W[
      -Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d
      -Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d
      -Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d
      -DSED=/usr/bin/sed
    ]
    system "cmake", ".", *std_cmake_args, *args
    system "make", "install"
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
