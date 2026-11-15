class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v9/nano-9.3.tar.xz"
  sha256 "a9affc52c9596ee0682bcdd4ceb3c0b235eb221d83d733dfd9b0dff45897cb0d"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "2791d87741b8f65529a08b22be01a73bbaf5a744521fa62699794c16601bd2e9"
    sha256 arm64_tahoe:       "9e71ede2a9944e90b78a5e41bba39c935a24db7011b98746bc09f0a44a374b6a"
    sha256 arm64_sequoia:     "a423e897b473dd3df29022aebf322940aa2c491bb7d8d2b132f7623ab8b105c4"
    sha256 arm64_linux:       "d01bbe39ec4daa51571968a609308bbeb51127fa795edfda9e5b678320ae5de1"
    sha256 x86_64_linux:      "fdfd36a96897a341ec02895569f71c7cf1a1b0e2d69ffdf2811518f689ca793b"
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

  deny_network_access!

  def install
    system "./autogen.sh" if build.head?
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
