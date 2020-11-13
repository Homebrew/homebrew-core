class Pulseaudio < Formula
  desc "Sound system for POSIX OSes"
  homepage "https://wiki.freedesktop.org/www/Software/PulseAudio/"
  url "https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-13.0.tar.xz"
  sha256 "961b23ca1acfd28f2bc87414c27bb40e12436efcf2158d29721b1e89f3f28057"
  revision 1

  # The regex here avoids x.99 releases, as they're pre-release versions.
  livecheck do
    url :stable
    regex(/href=["']?pulseaudio[._-]v?((?!\d+\.9\d+)\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "0e9445dd8d49abd299324e93f00231605e993f791674997d9d2c35b88efec528" => :catalina
    sha256 "ae68dfdb8ad584bf3f602ea7fb36d9bc1e4540e6905986a7129e45c6170d8d95" => :mojave
    sha256 "687c4c646487eb8a9988303e279dc2ee542b6404504cb54fcfce1d6d6bcf949f" => :high_sierra
  end

  head do
    url "https://anongit.freedesktop.org/git/pulseaudio/pulseaudio.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "intltool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libtool"
  depends_on "openssl@1.1"
  depends_on "speexdsp"

  uses_from_macos "perl" => :build
  uses_from_macos "expat"
  uses_from_macos "m4"

  on_linux do
    depends_on "glib"
    depends_on "libcap"

    # Depends on XML::Parser
    # Using the host's Perl interpreter to install XML::Parser fails when using brew's glibc.
    # Use brew's Perl interpreter instead.
    # See Linuxbrew/homebrew-core#8148
    resource "XML::Parser" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz"
      sha256 "1ae9d07ee9c35326b3d9aad56eae71a6730a73a116b9fe9e8a4758b7cc033216"
    end
  end

  def install
    on_linux do
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      resources.each do |res|
        res.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "PERL5LIB=#{ENV["PERL5LIB"]}", "CC=#{ENV.cc}"
          system "make", "install"
        end
      end
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-coreaudio-output
      --disable-neon-opt
      --disable-nls
      --disable-x11
    ]

    on_macos do
      args << "--with-mac-sysroot=#{MacOS.sdk_path})"
      args << "--with-mac-version-min=#{MacOS.version}"
    end

    on_linux do
      # Perl depends on gdbm.
      # If the dependency of pulseaudio on perl is build-time only,
      # pulseaudio detects and links gdbm at build-time, but cannot locate it at run-time.
      # Thus, we have to
      #  - specify not to use gdbm (with --with-database=simple), or
      #  - add a dependency on gdbm if gdbm is wanted (not implemented).
      # See Linuxbrew/homebrew-core#8148
      args << "--with-database=simple"
    end

    if build.head?
      # autogen.sh runs bootstrap.sh then ./configure
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"

    on_linux do
      # https://stackoverflow.com/questions/56309056/is-gschemas-compiled-architecture-specific-can-i-ship-it-with-my-python-library
      rm "#{share}/glib-2.0/schemas/gschemas.compiled"
    end
  end

  plist_options manual: "pulseaudio"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/pulseaudio</string>
          <string>--exit-idle-time=-1</string>
          <string>--verbose</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/#{name}.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/#{name}.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_match "module-sine", shell_output("#{bin}/pulseaudio --dump-modules")
  end
end
