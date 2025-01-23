class Mdbtools < Formula
  desc "Tools to facilitate the use of Microsoft Access databases"
  homepage "https://github.com/mdbtools/mdbtools/"
  url "https://github.com/mdbtools/mdbtools/releases/download/v1.0.1/mdbtools-1.0.1.tar.gz"
  sha256 "ff9c425a88bc20bf9318a332eec50b17e77896eef65a0e69415ccb4e396d1812"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3aab4c13461e0571b3ef4aa822417e0408fd7caad03f0d7d63bda9e20d102f20"
    sha256 cellar: :any,                 arm64_sonoma:  "c247b94b87f1f09c26953f4b3f923f345ba18a8764d8f5ffc0ca8060e557a5fe"
    sha256 cellar: :any,                 arm64_ventura: "ece916c2bc386781de20c67cc5e314430a369dc886d362f22039ea56d37771ee"
    sha256 cellar: :any,                 sonoma:        "49722390bf0230475a1261a0c10d90540b6ff056a07c54b74680eab7276c3a04"
    sha256 cellar: :any,                 ventura:       "2c2db546223c1b1ddfba20d70303761358fb5bba39362924976ff35d9710ae1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e2ca3b97c784e7ce3e9d42e0bf58e15816b94944f2686c41d6ec698fc50ca0f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "gawk" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--enable-man", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/mdb-schema --drop-table test 2>&1", 1)

    expected_output = <<~EOS
      File not found
      Could not open file
    EOS
    assert_match expected_output, output
  end
end
