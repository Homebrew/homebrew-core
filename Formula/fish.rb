class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.1.0/fish-3.1.0.tar.gz"
  sha256 "e5db1e6839685c56f172e1000c138e290add4aa521f187df4cd79d4eab294368"
  revision 1

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

  # Fixes severe performance issues with one of the default prompt
  # integrations. This has already been applied upstream and will
  # be in the next release.
  unless build.head?
    patch do
      url "https://github.com/Homebrew/formula-patches/raw/8743c955ae8809f692c92ef6b4bc78595bf98f50/fish/disable_svn_prompt.patch"
      sha256 "953dfc21f45575022d8f47c8654da1908682de1711712a60d4220e3a4c8133b9"
    end
  end

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
