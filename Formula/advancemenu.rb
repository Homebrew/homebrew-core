class Advancemenu < Formula
  desc "Frontend for AdvanceMAME/MESS"
  homepage "https://www.advancemame.it/menu-readme.html"
  url "https://github.com/amadvance/advancemame/releases/download/v3.9/advancemame-3.9.tar.gz"
  sha256 "3e4628e1577e70a1dbe104f17b1b746745b8eda80837f53fbf7b091c88be8c2b"

  bottle do
    cellar :any
    sha256 "cddc2110c8f7a94fff740ebb35d9d48fb5b47ccecbf92eedfc5ee28b28bfdd62" => :catalina
    sha256 "f1f5a182df60bf84339ff741e73dc464b209d87ed50f1b74bc671736eef6e300" => :mojave
    sha256 "a7e1ea0b085ec97b97bcb8f45ecd4221ad626a530a4d8b6dc1f56a3e85b9cf6a" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "sdl"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  conflicts_with "advancemame", :because => "both install `advmenu` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "LDFLAGS=#{ENV.ldflags}", "mandir=#{man}"
  end

  test do
    assert_match "Creating AdvanceMENU standard configuration file", shell_output("#{bin}/advmenu --default 2>&1")
  end
end
