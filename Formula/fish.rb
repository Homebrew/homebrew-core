class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.0.0/fish-3.0.0.tar.gz"
  sha256 "ea9dd3614bb0346829ce7319437c6a93e3e1dfde3b7f6a469b543b0d2c68f2cf"

  bottle do
    cellar :any
    sha256 "411c04301a63eb10c0e912193ffd5b60560f184d6361768c2557a79e0ee84b93" => :mojave
    sha256 "087eaab54dbb04f5269ef01ee7115797af291077fd2a89403dd392fbf97bc5c1" => :high_sierra
    sha256 "973773f553ea31c91816b102aac427bfaf71774c7ac2927dfd3e5d98c90ab151" => :sierra
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
