class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.1.1/fish-3.1.1.tar.gz"
  sha256 "07dc78eea3bc4cbd490b2f2a2e19e5771ac9e3b6b1a75893039ad8b34d6122b8"

  bottle do
    cellar :any
    sha256 "a78f5906eed06e141bc29f9e53a70a7995c51f59fd023e81f711c48a444e65e6" => :catalina
    sha256 "78db7552dea983ae9ac5720160a012d93546d037d6d4f06bf9857b518b64a903" => :mojave
    sha256 "b6fd10867ca24e5dbc708e0e8d9ff12fe615e76373e63e999475699dd691edc9" => :high_sierra
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
