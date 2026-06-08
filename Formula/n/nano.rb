class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v9/nano-9.0.tar.xz"
  sha256 "9f384374b496110a25b73ad5a5febb384783c6e3188b37063f677ac908013fde"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "23e7b2b57ceede9a52cd9209bb26aedda8443cd262b3eb06e60e2a5143e92568"
    sha256 arm64_sequoia: "dca384af42bb4ad013a5c7df20311ef4d51f5cfc2009cfafe4f20bb6070cc33a"
    sha256 arm64_sonoma:  "01e41aa134eef29246085b35b2ccc4e509624c2e7a69ec6467fbf0bdfa7030a1"
    sha256 sonoma:        "36fa3489bddca5793e81dcacfead40404c9c2c7afa786075e83668ce172e61b8"
    sha256 arm64_linux:   "98b84362acda79eb1f8c817566c5745da44f7c09a56432e2e305416651441f13"
    sha256 x86_64_linux:  "2ec7363d14f52dc35d09d40d6deaf81bf95e2fc0e7fe00284108897f79e5a65f"
  end

  head do
    url "https://git.savannah.gnu.org/git/nano.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "groff" => :build
    depends_on "texinfo" => :build

    on_linux do
      depends_on "gettext" => :build
    end
  end

  depends_on "pkgconf" => :build
  depends_on "ncurses"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libmagic"
  end

  def install
    if build.head?
      # `aclocal --print-ac-dir` returns automake's versioned path
      # which fails the check for `pkg.m4` since it is not there
      inreplace "configure.ac", "$(aclocal --print-ac-dir)", HOMEBREW_PREFIX/"share/aclocal"
      system "./autogen.sh"
    end

    system "./configure", "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--enable-utf8",
                          "--sysconfdir=#{etc}",
                          *std_configure_args
    system "make", "install"

    # Replace versioned paths from `sample.nanorc`
    brew_pkgshare = HOMEBREW_PREFIX/"share"/name
    inreplace "doc/sample.nanorc", pkgshare, brew_pkgshare
    # Copy sample so we can install a default configuration in `etc` as well
    cp "doc/sample.nanorc", "nanorc"
    doc.install "doc/sample.nanorc"

    # Enable syntax highlighting files (including extras) by default
    pkgshare.install Dir[pkgshare/"extra/*"]
    inreplace "nanorc", %r{^# (include #{brew_pkgshare}/\*\.nanorc)$}o, "\\1"
    etc.install "nanorc"
  end

  def caveats
    <<~EOS
      A sample configuration file is available at
        #{HOMEBREW_PREFIX}/share/doc/#{name}/sample.nanorc

      See `man nanorc` for more information.
    EOS
  end

  test do
    system bin/"nano", "--version"

    # Skip test on Intel macOS due to CI failures
    return if OS.mac? && Hardware::CPU.intel?

    PTY.spawn(bin/"nano", "test.txt") do |r, w, _pid|
      sleep 1
      w.write "test data"
      sleep 1
      w.write "\u0018" # Ctrl+X
      sleep 1
      w.write "y"      # Confirm save
      sleep 1
      w.write "\r"     # Enter to confirm filename
      sleep 1
      OS.mac? && r.read
    end

    assert_match "test data", (testpath/"test.txt").read
  end
end
