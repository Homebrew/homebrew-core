class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.0.0/fish-3.0.0.tar.gz"
  sha256 "ea9dd3614bb0346829ce7319437c6a93e3e1dfde3b7f6a469b543b0d2c68f2cf"

  bottle do
    sha256 "173bd50e5490974f8c980a022c4ed4c203d93c861d310ae319734b2233a465d0" => :mojave
    sha256 "b75d873885ecfe3a6e28e8de9a7f292b03c3fb3ebedd3d6ac7a74219148af04e" => :high_sierra
    sha256 "20e6c49692cef13eaadd8ee94e9831557130d449405fe12bfd9403659865f5b3" => :sierra
    sha256 "017610f146a161b4383b905a675ac935568a721ed042c3f41f97aaa7f4b5037b" => :el_capitan
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", :shallow => false

    depends_on "cmake" => :build
    depends_on "doxygen" => :build
  end

  depends_on "pcre2"

  def install
    if build.head?
      args = %W[
        -Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d
        -Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d
        -Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d
        -DSED=/usr/bin/sed
      ]
      system "cmake", ".", *std_cmake_args, *args
    else
      # In Homebrew's 'superenv' sed's path will be incompatible, so
      # the correct path is passed into configure here.
      args = %W[
        --prefix=#{prefix}
        --with-extra-functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d
        --with-extra-completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d
        --with-extra-confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d
        SED=/usr/bin/sed
      ]
      system "./configure", *args
    end
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
