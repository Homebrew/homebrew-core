class Id3v2 < Formula
  desc "Command-line editor"
  homepage "https://id3v2.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/id3v2/id3v2/0.1.12/id3v2-0.1.12.tar.gz"
  sha256 "8105fad3189dbb0e4cb381862b4fa18744233c3bbe6def6f81ff64f5101722bf"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "33aafe768f00f1a37dcc4a02ea2ebca5a06fe9548ee98fdab3b3f598ba641512"
    sha256 cellar: :any,                 arm64_sequoia: "87cb393fcb36c2c26e7af47a89e78da61e7a75e52d528a26191449f17c8a05f9"
    sha256 cellar: :any,                 arm64_sonoma:  "71bffeeec581154e8669d034472da305cdffc2daa2a21a01bdf5a267eae19e22"
    sha256 cellar: :any,                 sonoma:        "052436ce24f1730dc280abc7ee4c1ddecffef5d780d641e31c5cef5d9ceade1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07dfc1ddaa81bbfceb227d1394828d778d01e7348c579a40a939661cc0472b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1efae20c92b93c07d496412dea715097678914a077a2a52823a291687c3a3a2e"
  end

  depends_on "id3lib"

  uses_from_macos "mandoc" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # mandoc is only available since Ventura, but nroff is available for older macOS
    inreplace "Makefile", "nroff ", "mandoc " if !OS.mac? || MacOS.version >= :ventura

    # Fix linker flag order on Linux
    inreplace "Makefile", "-lz -lid3", "-lid3 -lz"

    # tarball includes a prebuilt Linux binary, which will get installed
    # by `make install` if `make clean` isn't run first
    system "make", "clean"
    bin.mkpath
    man1.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"id3v2", "--version"
  end
end
