class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.0.1/fish-3.0.1.tar.gz"
  sha256 "21677a5755ee1738bad2cf8179c104068f8bb81b969660d5a2af4ba6eceba5e4"

  bottle do
    cellar :any
    sha256 "799ebff30e1cd3ad00d468b90f8006f3e097dbb986a07aa003ad6cfb8eb5c261" => :mojave
    sha256 "6c7e17e508107b39c338a55fa51488b6df7d679e1dac9d12a3bf1bd80d6c0f27" => :high_sierra
    sha256 "8ac492a82ef5321d51b52e41cb54b084450514d02ab0e75c31cde1e29809e070" => :sierra
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", :shallow => false

    depends_on "doxygen" => :build
  end

  depends_on "cmake" => :build
  depends_on "pcre2"

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

  def caveats; <<~EOS
    You will need to add:
      #{HOMEBREW_PREFIX}/bin/fish
    to /etc/shells.

    Then run:
      chsh -s #{HOMEBREW_PREFIX}/bin/fish
    to make fish your default shell.
  EOS
  end

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end
