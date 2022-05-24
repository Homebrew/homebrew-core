class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.3.6.tar.gz"
  sha256 "fc68a66a216e304bb0e2ef627f767fff528f4fbf2bbda27e8cd8db1b7ba090b0"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3d3f7bbbeacdfc9b2391242f8d2ba757bbbf541bf154f52d8e0c482ab78cf82c"
    sha256 cellar: :any,                 arm64_big_sur:  "442d5d9a02f563243626299b1191c54196fbec963f67db229082785cef82211f"
    sha256 cellar: :any,                 monterey:       "319244d89ebc320de1c2074bc71e3579ffcfd1fa94ab1863adb05a5809163ff3"
    sha256 cellar: :any,                 big_sur:        "e242ad6aa6bbf01c16769afce5e97f96c9d9954fe0aa1b08d40a3e4c23f36289"
    sha256 cellar: :any,                 catalina:       "8ff648ec80d26251a697c76f4a219de20d39c7a51cc17c7d64b7b572f3029a35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c6e4b0ac90176f3fed6267dbb9c70303e8d42c4bc81ca95265244a4a49beca2"
  end

  depends_on "pkg-config" => :build
  depends_on "groonga"
  depends_on "postgresql"

  def install
    system "make"
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    stage_path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpath/stage_path/"lib").children
    share.install (buildpath/stage_path/"share").children
    include.install (buildpath/stage_path/"include").children
  end

  test do
    expected = "PGroonga database management module"
    assert_match expected, (share/"postgresql/extension/pgroonga_database.control").read
  end
end
