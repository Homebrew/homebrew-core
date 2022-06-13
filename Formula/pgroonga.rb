class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.3.7.tar.gz"
  sha256 "12876aa58177c0925d8331d91ea998d2db2b1766271a2ae741609668367dbfc1"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "16551ec9cfb78e392ae041b59a7100b45ee3f207e71667697eeee0cdc47f26b5"
    sha256 cellar: :any,                 arm64_big_sur:  "d018a14d3260ddb6328f3d21c543992d974597081c15c0d7d4a4a8b56d9c3aca"
    sha256 cellar: :any,                 monterey:       "abbd588474294ce7da953e43eafda79f76e4486815cc959af3aec2062a3a26b4"
    sha256 cellar: :any,                 big_sur:        "fe23a052e2261c20504b17112179e58bf622716546f1f892d747cff2dfcb27dc"
    sha256 cellar: :any,                 catalina:       "b93565f48e6629cc2f15c392153c5d28af30431240371ca2cabc4fdeac2b4793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e600bc5df63d1bc5f7229327fbb0cc6d36becd975abc59bd2227837580196c33"
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
