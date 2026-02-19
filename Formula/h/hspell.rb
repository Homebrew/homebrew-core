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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "c2f0ea64af6987d36f42b5f53aa51e781ff98cee49ea71b3f19d4137a8c4191b"
    sha256 arm64_sequoia: "35618c16a7d232caafdbd3727ac9a7a0c4150fe8dd342f5661cec2b11e59a75d"
    sha256 arm64_sonoma:  "4eb8d8495ab3c2b68c9ff12e6e5db38321ea050b49089162efbd2d9c15400daa"
    sha256 sonoma:        "d99dbc4d7a19a85cfcd36c2aa7623fe5e01b2172ee8251be627927b067167ea9"
    sha256 arm64_linux:   "9e22e4326c832b9a1e407c6f72a57a6a359395cff667db921c0d7080ef411cc0"
    sha256 x86_64_linux:  "52c6c0928b22dd5d7e72e08a48ae96ba44615336e24fe4ec677057a2d07fef36"
  end

  depends_on "autoconf" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # hspell was built for linux and compiles a .so shared library, to comply with macOS
  # standards this patch creates a .dylib instead
  patch :p0 do
    on_macos do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/hspell/1.3.patch"
      sha256 "63cc1bc753b1062d1144dcdd959a0a8f712b8872dce89e54ddff2d24f2ca2065"
    end
  end

  def install
    ENV.deparallelize

    # The build scripts rely on "." being in @INC which was disabled by default in perl 5.26
    ENV["PERL_USE_UNSAFE_INC"] = "1"

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
