class Hspell < Formula
  desc "Free Hebrew linguistic project"
  homepage "https://hspell.sourceforge.net/"
  url "https://hspell.sourceforge.net/hspell-1.4.tar.gz"
  sha256 "7310f5d58740d21d6d215c1179658602ef7da97a816bc1497c8764be97aabea3"
  license "AGPL-3.0-only"

  livecheck do
    url "https://hspell.sourceforge.net/download.html"
    regex(/href=.*?hspell[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :page_match
  end

  bottle do
    rebuild 3
    sha256 arm64_golden_gate: "37ba0b5de423be1dd2880eee9178d8f6f5dcb67080c3bf8b8a13639c47c13960"
    sha256 arm64_tahoe:       "ced3dddd83e4e604b53384cc4cecbeb45fd53d35867d8ff244abf4e8b3082b5c"
    sha256 arm64_sequoia:     "b2efb812718a75549385d7d46080ea9f365388fc69a1ee2b3432f9eb5e10f060"
    sha256 arm64_linux:       "d6f589171adb2c7cb2cc71dd6a3161ed259b5577e65b9c72d90484e0bc019599"
    sha256 x86_64_linux:      "8d328151358a39176cc2c5535297a2da376516401865c4593e7183886d9067a6"
  end

  depends_on "autoconf" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # hspell was built for linux and compiles a .so shared library, to comply with macOS
  # standards this patch creates a .dylib instead
  patch :p0 do
    on_macos do
      file "Patches/hspell/1.3.patch"
    end
  end

  def install
    ENV.deparallelize

    # The build scripts rely on "." being in @INC which was disabled by default in perl 5.26
    ENV["PERL_USE_UNSAFE_INC"] = "1"

    # C23 rejects the K&R-style function definitions in the bundled tclHash.c
    ENV.append_to_cflags "-std=gnu17"

    # autoconf needs to pick up on the patched configure.in and create a new ./configure
    # script
    system "autoconf"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "--enable-linginfo"
    system "make", "dolinginfo"
    system "make", "install"
  end

  test do
    File.open("test.txt", "w:ISO8859-8") do |f|
      f.write "שלום"
    end
    system bin/"hspell", "-l", "test.txt"
  end
end
